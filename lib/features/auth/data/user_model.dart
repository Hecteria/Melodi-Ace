import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String plan;
  final bool isAnonymous;
  final String deviceFingerprint;
  final List<String> linkedProviders;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.plan = 'starter',
    this.isAnonymous = true,
    required this.deviceFingerprint,
    this.linkedProviders = const ['anonymous'],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      plan: data['plan'] ?? 'starter',
      isAnonymous: data['isAnonymous'] ?? true,
      deviceFingerprint: data['deviceFingerprint'] ?? '',
      linkedProviders:
          List<String>.from(data['linkedProviders'] ?? ['anonymous']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'plan': plan,
      'isAnonymous': isAnonymous,
      'deviceFingerprint': deviceFingerprint,
      'linkedProviders': linkedProviders,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    String? plan,
    bool? isAnonymous,
    String? deviceFingerprint,
    List<String>? linkedProviders,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      plan: plan ?? this.plan,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
      linkedProviders: linkedProviders ?? this.linkedProviders,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
