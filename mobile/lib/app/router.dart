import 'package:flutter/material.dart';

import '../core/network/api_config.dart';
import '../core/network/http_api_client.dart';
import '../core/storage/secure_token_storage.dart';
import '../features/auth/data/repositories/backend_auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/main_navigation/presentation/screens/main_navigation_shell.dart';
import '../features/sleep_entry/data/repositories/mock_sleep_entry_repository.dart';
import '../features/sleep_entry/presentation/controllers/add_sleep_entry_controller.dart';
import '../features/sleep_entry/presentation/screens/add_sleep_entry_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const home = '/';
  static const addSleepEntry = '/sleep/add';
}

class AppRouter {
  const AppRouter._();

  static const _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: ApiConfig.baseUrl,
  );

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => switch (settings.name) {
        AppRoutes.login => LoginScreen(
            controller: AuthController(
              authRepository: BackendAuthRepository(
                apiClient: _buildApiClient(),
                tokenStorage: _tokenStorage,
              ),
            ),
          ),
        AppRoutes.home || null => const MainNavigationShell(),
        AppRoutes.addSleepEntry => AddSleepEntryScreen(
            controller: AddSleepEntryController(
              repository: MockSleepEntryRepository(),
            ),
          ),
        _ => const _NotFoundScreen(),
      },
    );
  }

  static final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  static HttpApiClient _buildApiClient() {
    return HttpApiClient(
      baseUrl: _apiBaseUrl,
      accessTokenReader: _tokenStorage.readAccessToken,
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
