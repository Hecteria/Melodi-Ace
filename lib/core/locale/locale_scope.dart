import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'locale_controller.dart';

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleScope>()!.notifier!;
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
