enum PhysicalActivityLevel {
  none,
  light,
  moderate,
  intense,
}

enum SleepMood {
  calm,
  tired,
  stressed,
  energized,
}

enum SleepDataSource {
  manual,
  wearable,
}

class SleepEntryDraft {
  const SleepEntryDraft({
    required this.sleepStartMinutes,
    required this.wakeTimeMinutes,
    required this.qualityRating,
    required this.stressLevel,
    required this.caffeineCupsBeforeSleep,
    required this.screenTimeBeforeBedMinutes,
    required this.physicalActivity,
    required this.mood,
    required this.notes,
    this.source = SleepDataSource.manual,
    this.awakeMinutes,
    this.lightSleepMinutes,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.averageHeartRate,
    this.nightHeartRate,
    this.spo2,
  });

  final int sleepStartMinutes;
  final int wakeTimeMinutes;
  final int qualityRating;
  final int stressLevel;
  final int caffeineCupsBeforeSleep;
  final int screenTimeBeforeBedMinutes;
  final PhysicalActivityLevel physicalActivity;
  final SleepMood mood;
  final String notes;
  final SleepDataSource source;
  final int? awakeMinutes;
  final int? lightSleepMinutes;
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final int? averageHeartRate;
  final int? nightHeartRate;
  final int? spo2;

  Duration get sleepDuration {
    final normalizedWakeTime = wakeTimeMinutes <= sleepStartMinutes
        ? wakeTimeMinutes + Duration.minutesPerDay
        : wakeTimeMinutes;

    return Duration(minutes: normalizedWakeTime - sleepStartMinutes);
  }

  int get durationMinutes => sleepDuration.inMinutes;

  double? get sleepEfficiency {
    final awakeTime = awakeMinutes;

    if (awakeTime == null) {
      return null;
    }

    final timeInBedMinutes = durationMinutes + awakeTime;

    if (timeInBedMinutes <= 0) {
      return null;
    }

    return durationMinutes / timeInBedMinutes;
  }

  bool get hasSleepPhases {
    return lightSleepMinutes != null ||
        deepSleepMinutes != null ||
        remSleepMinutes != null ||
        awakeMinutes != null;
  }

  bool get hasPhysiologicalMetrics {
    return averageHeartRate != null || nightHeartRate != null || spo2 != null;
  }
}
