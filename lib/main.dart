import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/locale/locale_controller.dart';
import 'core/locale/locale_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A1C),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MelodiApp());
}

class MelodiApp extends StatefulWidget {
  const MelodiApp({super.key});

  @override
  State<MelodiApp> createState() => _MelodiAppState();
}

class _MelodiAppState extends State<MelodiApp> {
  final _localeController = LocaleController();

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _localeController,
      child: ListenableBuilder(
        listenable: _localeController,
        builder: (context, _) => MaterialApp(
          title: 'Melodi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: _localeController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AuthGate(),
        ),
      ),
    );
  }
}
