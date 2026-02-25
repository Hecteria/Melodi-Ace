import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/auth/data/device_model.dart';
import '../../features/auth/data/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Anonymous Auth ──

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // ── Device CRUD ──

  Future<DeviceModel?> getDeviceDocument(String fingerprint) async {
    final doc = await _firestore.collection('devices').doc(fingerprint).get();
    if (!doc.exists) return null;
    return DeviceModel.fromFirestore(doc);
  }

  Future<DeviceModel> createDeviceDocument({
    required String fingerprint,
    required String authUid,
    required String platform,
    required int initialCredits,
  }) async {
    final now = DateTime.now();
    final device = DeviceModel(
      fingerprint: fingerprint,
      generationCredits: initialCredits,
      initialCreditsGranted: initialCredits > 0,
      currentAuthUid: authUid,
      platform: platform,
      createdAt: now,
      lastSeenAt: now,
    );

    await _firestore
        .collection('devices')
        .doc(fingerprint)
        .set(device.toFirestore());

    return device;
  }

  Future<void> updateDeviceAuth({
    required String fingerprint,
    required String authUid,
  }) async {
    await _firestore.collection('devices').doc(fingerprint).update({
      'currentAuthUid': authUid,
      'lastSeenAt': Timestamp.now(),
    });
  }

  // ── Credit Transaction ──

  Future<bool> useGenerationCredit(String fingerprint) async {
    final docRef = _firestore.collection('devices').doc(fingerprint);

    return _firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return false;

      final currentCredits = snapshot.data()?['generationCredits'] ?? 0;
      if (currentCredits <= 0) return false;

      transaction.update(docRef, {
        'generationCredits': currentCredits - 1,
        'lastSeenAt': Timestamp.now(),
      });
      return true;
    });
  }

  // ── User CRUD ──

  Future<UserModel> createAnonymousUserDocument({
    required String uid,
    required String deviceFingerprint,
  }) async {
    final now = DateTime.now();
    final userModel = UserModel(
      uid: uid,
      email: '',
      displayName: 'Guest',
      deviceFingerprint: deviceFingerprint,
      isAnonymous: true,
      linkedProviders: const ['anonymous'],
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(userModel.toFirestore());

    return userModel;
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  // ── Google Sign-In (Link or Sign In) ──

  /// Tries to link Google to current anonymous account.
  /// If the Google account is already linked to another Firebase user,
  /// falls back to signing in with that Google account directly.
  /// Returns (userCredential, isLinked) where isLinked means it was linked
  /// to the existing anonymous account (same UID preserved).
  Future<({UserCredential credential, bool linked})>
      linkOrSignInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final oauthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final currentFirebaseUser = _auth.currentUser;

    // If user is anonymous, try linking first
    if (currentFirebaseUser != null && currentFirebaseUser.isAnonymous) {
      try {
        final linked =
            await currentFirebaseUser.linkWithCredential(oauthCredential);

        // Update user doc for linked account
        await _firestore.collection('users').doc(currentFirebaseUser.uid).update({
          'isAnonymous': false,
          'email': googleUser.email,
          'displayName': googleUser.displayName ?? 'User',
          'photoUrl': googleUser.photoUrl,
          'linkedProviders': FieldValue.arrayUnion(['google.com']),
          'updatedAt': Timestamp.now(),
        });

        return (credential: linked, linked: true);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use') {
          // Google account already belongs to another user → sign in directly
          final signedIn =
              await _auth.signInWithCredential(oauthCredential);
          return (credential: signedIn, linked: false);
        }
        rethrow;
      }
    }

    // Not anonymous (or no user) → just sign in
    final signedIn = await _auth.signInWithCredential(oauthCredential);

    // Ensure user doc exists
    final userDoc = await _firestore
        .collection('users')
        .doc(signedIn.user!.uid)
        .get();
    if (!userDoc.exists) {
      final now = DateTime.now();
      await _firestore.collection('users').doc(signedIn.user!.uid).set(
            UserModel(
              uid: signedIn.user!.uid,
              email: googleUser.email,
              displayName: googleUser.displayName ?? 'User',
              photoUrl: googleUser.photoUrl,
              deviceFingerprint: '',
              isAnonymous: false,
              linkedProviders: const ['google.com'],
              createdAt: now,
              updatedAt: now,
            ).toFirestore(),
          );
    }

    return (credential: signedIn, linked: false);
  }

  // ── Legacy Email/Password (preserved) ──

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
    required String deviceFingerprint,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(displayName);

    final now = DateTime.now();
    final userModel = UserModel(
      uid: credential.user!.uid,
      email: email,
      displayName: displayName,
      deviceFingerprint: deviceFingerprint,
      isAnonymous: false,
      linkedProviders: const ['password'],
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set(userModel.toFirestore());

    return userModel;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    if (!doc.exists) {
      final now = DateTime.now();
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: credential.user!.displayName ?? email.split('@').first,
        deviceFingerprint: '',
        isAnonymous: false,
        linkedProviders: const ['password'],
        createdAt: now,
        updatedAt: now,
      );
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());
      return userModel;
    }

    return UserModel.fromFirestore(doc);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.now(),
    };
    if (displayName != null) updates['displayName'] = displayName;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;

    await _firestore.collection('users').doc(uid).update(updates);
  }
}
