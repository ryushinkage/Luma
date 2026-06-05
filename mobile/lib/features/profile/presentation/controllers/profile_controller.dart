import 'package:flutter/foundation.dart';

import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({
    required ProfileRepository repository,
  }) : _repository = repository;

  final ProfileRepository _repository;

  ProfileState _state = const ProfileState.initial();

  ProfileState get state => _state;

  Future<void> loadProfile() async {
    _setState(const ProfileState(status: ProfileStatus.loading));

    try {
      final profile = await _repository.getCurrentProfile();

      _setState(
        ProfileState(
          status: ProfileStatus.ready,
          profile: profile,
        ),
      );
    } on Exception {
      _setState(
        const ProfileState(
          status: ProfileStatus.failure,
          errorMessage: 'Не удалось загрузить профиль. Попробуйте еще раз.',
        ),
      );
    }
  }

  Future<bool> signOut() async {
    final currentProfile = _state.profile;

    _setState(
      ProfileState(
        status: ProfileStatus.signingOut,
        profile: currentProfile,
      ),
    );

    try {
      await _repository.signOut();
      return true;
    } on Exception {
      _setState(
        ProfileState(
          status: ProfileStatus.failure,
          profile: currentProfile,
          errorMessage: 'Не удалось выйти из аккаунта. Попробуйте еще раз.',
        ),
      );
      return false;
    }
  }

  void _setState(ProfileState state) {
    _state = state;
    notifyListeners();
  }
}
