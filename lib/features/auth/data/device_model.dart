import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String fingerprint;
  final int generationCredits;
  final bool initialCreditsGranted;
  final String currentAuthUid;
  final String platform;
  final DateTime createdAt;
  final DateTime lastSeenAt;

  const DeviceModel({
    required this.fingerprint,
    required this.generationCredits,
    required this.initialCreditsGranted,
    required this.currentAuthUid,
    required this.platform,
    required this.createdAt,
    required this.lastSeenAt,
  });

  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeviceModel(
      fingerprint: doc.id,
      generationCredits: data['generationCredits'] ?? 0,
      initialCreditsGranted: data['initialCreditsGranted'] ?? false,
      currentAuthUid: data['currentAuthUid'] ?? '',
      platform: data['platform'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastSeenAt: (data['lastSeenAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'generationCredits': generationCredits,
      'initialCreditsGranted': initialCreditsGranted,
      'currentAuthUid': currentAuthUid,
      'platform': platform,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeenAt': Timestamp.fromDate(lastSeenAt),
    };
  }

  DeviceModel copyWith({
    int? generationCredits,
    bool? initialCreditsGranted,
    String? currentAuthUid,
    DateTime? lastSeenAt,
  }) {
    return DeviceModel(
      fingerprint: fingerprint,
      generationCredits: generationCredits ?? this.generationCredits,
      initialCreditsGranted:
          initialCreditsGranted ?? this.initialCreditsGranted,
      currentAuthUid: currentAuthUid ?? this.currentAuthUid,
      platform: platform,
      createdAt: createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
