import '../../domain/entities/auth_onboarding_draft.dart';

class OnboardingProfileRequest {
  const OnboardingProfileRequest({
    required this.usualSleepTimeMinutes,
    required this.usualWakeTimeMinutes,
    required this.improvementGoal,
  });

  final int usualSleepTimeMinutes;
  final int usualWakeTimeMinutes;
  final String improvementGoal;

  factory OnboardingProfileRequest.fromDraft(AuthOnboardingDraft draft) {
    return OnboardingProfileRequest(
      usualSleepTimeMinutes: draft.usualSleepTimeMinutes,
      usualWakeTimeMinutes: draft.usualWakeTimeMinutes,
      improvementGoal: draft.improvementGoal,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'usualSleepTimeMinutes': usualSleepTimeMinutes,
      'usualWakeTimeMinutes': usualWakeTimeMinutes,
      'improvementGoal': improvementGoal,
    };
  }
}
