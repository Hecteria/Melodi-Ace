import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/services/auth_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shell/main_shell.dart';
import '../controllers/auth_controller.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthController _controller = AuthController();

  void _retry() {
    _controller.dispose();
    setState(() {
      _controller = AuthController();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        switch (_controller.status) {
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          case AuthStatus.authenticated:
            return AuthScope(
              controller: _controller,
              child: const MainShell(),
            );
          case AuthStatus.unauthenticated:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.primary,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.connectionError,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _controller.error ?? context.l10n.somethingWentWrong,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white54,
                                ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _retry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(context.l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
