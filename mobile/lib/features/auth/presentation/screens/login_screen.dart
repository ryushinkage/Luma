import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.controller,
    super.key,
  });

  final AuthController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleAuthStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleAuthStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleAuthStateChanged() {
    if (!mounted || !_controller.state.isAuthenticated) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.backgroundGlow),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final state = _controller.state;

                    return GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(24),
                      glowColor: const Color(0x267C5CFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.bedtime_outlined,
                            size: 56,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Ласкаво просимо до Sleep Analytics',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Увійдіть, щоб відстежувати сон і отримувати персональні рекомендації для відновлення.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          GradientButton(
                            onPressed: state.isLoading
                                ? null
                                : _controller.signInWithGoogle,
                            icon: Icons.login,
                            isLoading: state.isLoading,
                            label: state.isLoading
                                ? 'Входимо...'
                                : 'Увійти через Google',
                          ),
                          if (state.status == AuthStatus.failure) ...[
                            const SizedBox(height: 16),
                            Text(
                              state.errorMessage ?? 'Не вдалося увійти.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
