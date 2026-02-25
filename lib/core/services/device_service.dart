import 'dart:io';
import 'dart:math';
import 'package:android_id/android_id.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceService {
  static const _iosKeychainKey = 'melodi_device_id';

  Future<String> getDeviceFingerprint() {
    if (Platform.isAndroid) {
      return _getAndroidId();
    } else if (Platform.isIOS) {
      return _getIosKeychainId();
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  String get platformName {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  Future<String> _getAndroidId() async {
    final androidId = await const AndroidId().getId();
    if (androidId == null || androidId.isEmpty) {
      throw StateError('Could not retrieve Android ID');
    }
    return androidId;
  }

  Future<String> _getIosKeychainId() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    var deviceId = await storage.read(key: _iosKeychainKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _generateUuid();
      await storage.write(key: _iosKeychainKey, value: deviceId);
    }
    return deviceId;
  }

  String _generateUuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // variant 1
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
