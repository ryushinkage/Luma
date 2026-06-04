import '../entities/user_profile_snapshot.dart';

abstract interface class ProfileRepository {
  Future<UserProfileSnapshot> getCurrentProfile();

  Future<void> signOut();
}
