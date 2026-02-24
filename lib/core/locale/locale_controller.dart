import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _key = 'locale';
  static const _supportedCodes = ['en', 'tr'];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _locale = Locale(saved);
    } else {
      // First launch: use device language if supported
      final deviceCode = PlatformDispatcher.instance.locale.languageCode;
      if (_supportedCodes.contains(deviceCode)) {
        _locale = Locale(deviceCode);
      }
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
