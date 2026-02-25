import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/device_service.dart';
import '../data/device_model.dart';
import '../data/user_model.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DeviceService _deviceService = DeviceService();

  AuthStatus _status = AuthStatus.loading;
  UserModel? _userModel;
  DeviceModel? _deviceModel;
  String? _deviceFingerprint;
  String? _error;
  bool _busy = false;

  AuthStatus get status => _status;
  UserModel? get userModel => _userModel;
  DeviceModel? get deviceModel => _deviceModel;
  String? get error => _error;
  bool get busy => _busy;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  int get generationCredits => _deviceModel?.generationCredits ?? 0;

  AuthController() {
    _init();
  }

  Future<void> _init() async {
    try {
      // 1. Get device fingerprint
      _deviceFingerprint = await _deviceService.getDeviceFingerprint();

      // 2. Check if already signed in (e.g. Google user returning)
      final existingUser = _authService.currentUser;
      if (existingUser != null && !existingUser.isAnonymous) {
        // Returning authenticated user (Google/email)
        await _handleReturningUser(existingUser);
        return;
      }

      // 3. Run guest flow (anonymous sign-in)
      await _runGuestFlow();
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _runGuestFlow() async {
    // Sign in anonymously
    final credential = await _authService.signInAnonymously();
    final uid = credential.user!.uid;
    final fingerprint = _deviceFingerprint!;
    final platform = _deviceService.platformName;

    // Check existing device document
    final existingDevice = await _authService.getDeviceDocument(fingerprint);

    if (existingDevice == null) {
      // Scenario 1: First install — new device
      _deviceModel = await _authService.createDeviceDocument(
        fingerprint: fingerprint,
        authUid: uid,
        platform: platform,
        initialCredits: 10,
      );
    } else {
      // Scenario 2: Reinstall — same device, credits preserved
      await _authService.updateDeviceAuth(
        fingerprint: fingerprint,
        authUid: uid,
      );
      _deviceModel = existingDevice.copyWith(
        currentAuthUid: uid,
        lastSeenAt: DateTime.now(),
      );
    }

    // Create user document only on first sign-in; reuse on subsequent launches
    _userModel = await _authService.getCurrentUserModel();
    _userModel ??= await _authService.createAnonymousUserDocument(
      uid: uid,
      deviceFingerprint: fingerprint,
    );

    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> _handleReturningUser(User user) async {
    // Load user model
    _userModel = await _authService.getCurrentUserModel();

    // Load or create device doc for current device
    final fingerprint = _deviceFingerprint!;
    final existingDevice = await _authService.getDeviceDocument(fingerprint);

    if (existingDevice != null) {
      // Device doc exists — update auth uid
      await _authService.updateDeviceAuth(
        fingerprint: fingerprint,
        authUid: user.uid,
      );
      _deviceModel = existingDevice.copyWith(
        currentAuthUid: user.uid,
        lastSeenAt: DateTime.now(),
      );
    } else {
      // Scenario 5: New device + returning Google user — NO free credits
      _deviceModel = await _authService.createDeviceDocument(
        fingerprint: fingerprint,
        authUid: user.uid,
        platform: _deviceService.platformName,
        initialCredits: 0,
      );
    }

    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  // ── Google Account Linking ──

  Future<bool> linkWithGoogle() async {
    _setBusy(true);
    _error = null;
    try {
      final result = await _authService.linkOrSignInWithGoogle();

      if (result.linked) {
        // Scenario 3: Successfully linked — same UID, same device
        _userModel = await _authService.getCurrentUserModel();
      } else {
        // Scenario 6: Conflict — signed into existing Google account
        final user = result.credential.user!;
        _userModel = await _authService.getCurrentUserModel();

        // Update device to point to this user
        if (_deviceFingerprint != null) {
          await _authService.updateDeviceAuth(
            fingerprint: _deviceFingerprint!,
            authUid: user.uid,
          );
        }
      }

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'sign-in-cancelled') {
        // User cancelled, not an error to display
        return false;
      }
      _error = _mapAuthError(e.code);
      return false;
    } finally {
      _setBusy(false);
    }
  }

  // ── Credit Usage ──

  Future<bool> useCredit() async {
    if (_deviceFingerprint == null) return false;

    final success =
        await _authService.useGenerationCredit(_deviceFingerprint!);
    if (success && _deviceModel != null) {
      _deviceModel = _deviceModel!.copyWith(
        generationCredits: _deviceModel!.generationCredits - 1,
      );
      notifyListeners();
    }
    return success;
  }

  /// Refreshes device model from Firestore to get latest credit count.
  Future<void> refreshCredits() async {
    if (_deviceFingerprint == null) return;
    final device =
        await _authService.getDeviceDocument(_deviceFingerprint!);
    if (device != null) {
      _deviceModel = device;
      notifyListeners();
    }
  }

  // ── Sign Out ──

  Future<void> signOut() async {
    await _authService.signOut();
    _userModel = null;
    _deviceModel = null;
    _status = AuthStatus.loading;
    notifyListeners();

    // Re-enter as guest
    try {
      await _runGuestFlow();
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // ── Legacy Email/Password (preserved) ──

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setBusy(true);
    _error = null;
    try {
      _userModel = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
        deviceFingerprint: _deviceFingerprint ?? '',
      );
      _status = AuthStatus.authenticated;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      return false;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    _error = null;
    try {
      _userModel = await _authService.signIn(
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      return false;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setBusy(true);
    _error = null;
    try {
      await _authService.resetPassword(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      return false;
    } finally {
      _setBusy(false);
    }
  }

  // ── Helpers ──

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'credential-already-in-use':
        return 'This account is already linked to another user.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
