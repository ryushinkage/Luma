import 'package:flutter/material.dart';

import '../features/auth/data/repositories/in_memory_token_storage.dart';
import '../features/auth/data/repositories/mock_auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/main_navigation/presentation/screens/main_navigation_shell.dart';

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const home = '/';
}

class AppRouter {
  const AppRouter._();

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => switch (settings.name) {
        AppRoutes.login => LoginScreen(
            controller: AuthController(
              authRepository: MockAuthRepository(
                tokenStorage: InMemoryTokenStorage(),
              ),
            ),
          ),
        AppRoutes.home || null => const MainNavigationShell(),
        _ => const _NotFoundScreen(),
      },
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Сторінку не знайдено'),
      ),
    );
  }
}
