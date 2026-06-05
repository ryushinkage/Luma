import 'package:flutter/foundation.dart';

import '../../domain/entities/sleep_entry_draft.dart';
import '../../domain/repositories/sleep_entry_repository.dart';

class AddSleepEntryController extends ChangeNotifier {
  AddSleepEntryController({
    required SleepEntryRepository repository,
  }) : _repository = repository;

  final SleepEntryRepository _repository;

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  Future<AddSleepEntryResult> save(SleepEntryDraft draft) async {
    final validationMessage = _validate(draft);

    if (validationMessage != null) {
      return AddSleepEntryResult.failure(validationMessage);
    }

    _setSaving(true);

    try {
      await _repository.saveSleepEntry(draft);
      return const AddSleepEntryResult.success();
    } on Exception {
      return const AddSleepEntryResult.failure(
        'Не удалось сохранить запись сна локально. Попробуйте еще раз.',
      );
    } finally {
      _setSaving(false);
    }
  }

  String? _validate(SleepEntryDraft draft) {
    if (draft.sleepStartMinutes == draft.wakeTimeMinutes) {
      return 'Время пробуждения должно быть после времени отхода ко сну.';
    }

    if (draft.sleepDuration < const Duration(minutes: 30)) {
      return 'Длительность сна должна быть не меньше 30 минут.';
    }

    if (draft.qualityRating < 1 || draft.qualityRating > 10) {
      return 'Оцените качество сна от 1 до 10.';
    }

    if (draft.stressLevel < 1 || draft.stressLevel > 10) {
      return 'Оцените уровень стресса от 1 до 10.';
    }

    if (draft.caffeineCupsBeforeSleep < 0 ||
        draft.caffeineCupsBeforeSleep > 5) {
      return 'Количество кофе перед сном должно быть от 0 до 5 чашек.';
    }

    final phaseValues = [
      draft.awakeMinutes,
      draft.lightSleepMinutes,
      draft.deepSleepMinutes,
      draft.remSleepMinutes,
    ].whereType<int>();

    if (phaseValues.any((value) => value < 0)) {
      return 'Фазы сна и время бодрствования не могут быть отрицательными.';
    }

    final sleepPhaseSum = [
      draft.lightSleepMinutes,
      draft.deepSleepMinutes,
      draft.remSleepMinutes,
    ].whereType<int>().fold(0, (sum, value) => sum + value);

    if (sleepPhaseSum > draft.durationMinutes) {
      return 'Сумма фаз сна не должна превышать длительность сна.';
    }

    if (draft.awakeMinutes != null && draft.awakeMinutes! > 240) {
      return 'Время бодрствования ночью выглядит слишком большим для ручной записи.';
    }

    if (draft.averageHeartRate != null &&
        (draft.averageHeartRate! < 30 || draft.averageHeartRate! > 220)) {
      return 'Средний пульс должен быть в реалистичном диапазоне.';
    }

    if (draft.nightHeartRate != null &&
        (draft.nightHeartRate! < 30 || draft.nightHeartRate! > 220)) {
      return 'Ночной пульс должен быть в реалистичном диапазоне.';
    }

    if (draft.spo2 != null && (draft.spo2! < 50 || draft.spo2! > 100)) {
      return 'SpO₂ должен быть от 50 до 100%.';
    }

    return null;
  }

  void _setSaving(bool isSaving) {
    _isSaving = isSaving;
    notifyListeners();
  }
}

class AddSleepEntryResult {
  const AddSleepEntryResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  const AddSleepEntryResult.success()
      : this._(
          isSuccess: true,
        );

  const AddSleepEntryResult.failure(String errorMessage)
      : this._(
          isSuccess: false,
          errorMessage: errorMessage,
        );

  final bool isSuccess;
  final String? errorMessage;
}
