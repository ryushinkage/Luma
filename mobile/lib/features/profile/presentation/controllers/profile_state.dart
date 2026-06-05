import '../../domain/entities/user_profile_snapshot.dart';

enum ProfileStatus {
  initial,
  loading,
  ready,
  signingOut,
  failure,
}

class ProfileState {
  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  const ProfileState.initial()
      : this(
          status: ProfileStatus.initial,
        );

  final ProfileStatus status;
  final UserProfileSnapshot? profile;
  final String? errorMessage;

  bool get isLoading {
    return status == ProfileStatus.initial || status == ProfileStatus.loading;
  }

  bool get isSigningOut => status == ProfileStatus.signingOut;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileSnapshot? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}
