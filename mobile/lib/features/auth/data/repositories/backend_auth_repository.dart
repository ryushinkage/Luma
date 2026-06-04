import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/auth_onboarding_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/token_storage.dart';
import '../models/auth_session_response.dart';
import '../models/email_password_auth_request.dart';
import '../models/onboarding_profile_request.dart';

class BackendAuthRepository implements AuthRepository {
  const BackendAuthRepository({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      ApiEndpoints.authEmailPasswordLogin,
      body: EmailPasswordAuthRequest(
        email: email,
        password: password,
      ).toJson(),
    );

    await _saveSession(response);
  }

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      ApiEndpoints.authEmailPasswordRegister,
      body: EmailPasswordAuthRequest(
        email: email,
        password: password,
      ).toJson(),
    );

    await _saveSessionIfPresent(response);
  }

  @override
  Future<void> saveOnboardingDraft(AuthOnboardingDraft draft) async {
    await _apiClient.postJson(
      ApiEndpoints.onboardingProfile,
      body: OnboardingProfileRequest.fromDraft(draft).toJson(),
    );
  }

  @override
  Future<void> signOut() async {
    await _apiClient.postJson(ApiEndpoints.authLogout);
    await _tokenStorage.clear();
  }

  Future<void> _saveSession(Map<String, Object?> response) async {
    final session = AuthSessionResponse.fromJson(response);
    await _tokenStorage.saveAccessToken(session.accessToken);
  }

  Future<void> _saveSessionIfPresent(Map<String, Object?> response) async {
    final accessToken = AuthSessionResponse.findAccessToken(response);
    if (accessToken == null) {
      return;
    }

    await _tokenStorage.saveAccessToken(accessToken);
  }
}
