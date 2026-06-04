import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../../domain/entities/sleep_entry_draft.dart';
import '../controllers/add_sleep_entry_controller.dart';

class AddSleepEntryScreen extends StatefulWidget {
  const AddSleepEntryScreen({
    required this.controller,
    super.key,
  });

  final AddSleepEntryController controller;

  @override
  State<AddSleepEntryScreen> createState() => _AddSleepEntryScreenState();
}

class _AddSleepEntryScreenState extends State<AddSleepEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _awakeMinutesController = TextEditingController(text: '18');
  final _lightSleepMinutesController = TextEditingController();
  final _deepSleepMinutesController = TextEditingController();
  final _remSleepMinutesController = TextEditingController();
  final _averageHeartRateController = TextEditingController();
  final _nightHeartRateController = TextEditingController();
  final _spo2Controller = TextEditingController();

  TimeOfDay? _sleepStartTime = const TimeOfDay(hour: 23, minute: 30);
  TimeOfDay? _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  int _qualityRating = 8;
  int _stressLevel = 4;
  int _caffeineCupsBeforeSleep = 0;
  int _screenTimeBeforeBedMinutes = 60;
  PhysicalActivityLevel _physicalActivity = PhysicalActivityLevel.moderate;
  SleepMood _mood = SleepMood.calm;
  SleepDataSource _source = SleepDataSource.manual;
  String? _formError;

  AddSleepEntryController get _controller => widget.controller;

  @override
  void dispose() {
    _notesController.dispose();
    _awakeMinutesController.dispose();
    _lightSleepMinutesController.dispose();
    _deepSleepMinutesController.dispose();
    _remSleepMinutesController.dispose();
    _averageHeartRateController.dispose();
    _nightHeartRateController.dispose();
    _spo2Controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectSleepStartTime() async {
    final selectedTime = await _showTimePicker(
      label: 'Время отхода ко сну',
      initialTime: _sleepStartTime ?? const TimeOfDay(hour: 23, minute: 0),
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      _sleepStartTime = selectedTime;
      _formError = null;
    });
  }

  Future<void> _selectWakeTime() async {
    final selectedTime = await _showTimePicker(
      label: 'Время пробуждения',
      initialTime: _wakeTime ?? const TimeOfDay(hour: 7, minute: 0),
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      _wakeTime = selectedTime;
      _formError = null;
    });
  }

  Future<TimeOfDay?> _showTimePicker({
    required String label,
    required TimeOfDay initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: label,
      cancelText: 'Отмена',
      confirmText: 'Готово',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sleepStartTime = _sleepStartTime;
    final wakeTime = _wakeTime;

    if (sleepStartTime == null || wakeTime == null) {
      setState(() {
        _formError = 'Выберите время отхода ко сну и пробуждения.';
      });
      return;
    }

    final result = await _controller.save(
      SleepEntryDraft(
        sleepStartMinutes: _minutesFromTime(sleepStartTime),
        wakeTimeMinutes: _minutesFromTime(wakeTime),
        qualityRating: _qualityRating,
        stressLevel: _stressLevel,
        caffeineCupsBeforeSleep: _caffeineCupsBeforeSleep,
        screenTimeBeforeBedMinutes: _screenTimeBeforeBedMinutes,
        physicalActivity: _physicalActivity,
        mood: _mood,
        notes: _notesController.text.trim(),
        source: _source,
        awakeMinutes: _optionalInt(_awakeMinutesController),
        lightSleepMinutes: _optionalInt(_lightSleepMinutesController),
        deepSleepMinutes: _optionalInt(_deepSleepMinutesController),
        remSleepMinutes: _optionalInt(_remSleepMinutesController),
        averageHeartRate: _optionalInt(_averageHeartRateController),
        nightHeartRate: _optionalInt(_nightHeartRateController),
        spo2: _optionalInt(_spo2Controller),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Запись сна сохранена локально как mock-данные.'),
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _formError = result.errorMessage;
    });
  }

  int _minutesFromTime(TimeOfDay time) {
    return time.hour * Duration.minutesPerHour + time.minute;
  }

  int? _optionalInt(TextEditingController controller) {
    final value = controller.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return int.tryParse(value);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Не выбрано';
    }

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _durationPreview() {
    final sleepStartTime = _sleepStartTime;
    final wakeTime = _wakeTime;

    if (sleepStartTime == null || wakeTime == null) {
      return 'Выберите время';
    }

    final start = _minutesFromTime(sleepStartTime);
    final wake = _minutesFromTime(wakeTime);
    final normalizedWake = wake <= start ? wake + Duration.minutesPerDay : wake;
    final duration = Duration(minutes: normalizedWake - start);

    return '${duration.inHours}ч ${duration.inMinutes.remainder(60)}м';
  }

  String? _validateOptionalNumber(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return null;
    }

    if (int.tryParse(trimmed) == null) {
      return 'Введите целое число';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить запись сна'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.backgroundGlow),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Быстрая запись ночи',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Основные поля соответствуют SleepRecord. Факторы дня '
                        'сохраняются как BehaviorFactor/DailyFactor, а фазы '
                        'и физиология остаются optional.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SleepRecordCard(
                        sleepStartValue: _formatTime(_sleepStartTime),
                        wakeValue: _formatTime(_wakeTime),
                        durationValue: _durationPreview(),
                        source: _source,
                        onSleepStartPressed: _selectSleepStartTime,
                        onWakePressed: _selectWakeTime,
                        onSourceChanged: (source) {
                          setState(() {
                            _source = source;
                            _formError = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        borderRadius: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RatingSlider(
                              label: 'Subjective quality',
                              value: _qualityRating,
                              leadingLabel: 'низкое',
                              trailingLabel: 'высокое',
                              onChanged: (value) {
                                setState(() {
                                  _qualityRating = value;
                                  _formError = null;
                                });
                              },
                            ),
                            const SizedBox(height: 22),
                            _RatingSlider(
                              label: 'Stress level',
                              value: _stressLevel,
                              leadingLabel: 'низкий',
                              trailingLabel: 'высокий',
                              onChanged: (value) {
                                setState(() {
                                  _stressLevel = value;
                                  _formError = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _BehaviorFactorCard(
                        caffeineCupsBeforeSleep: _caffeineCupsBeforeSleep,
                        screenTimeBeforeBedMinutes: _screenTimeBeforeBedMinutes,
                        physicalActivity: _physicalActivity,
                        mood: _mood,
                        onCaffeineChanged: (value) {
                          setState(() {
                            _caffeineCupsBeforeSleep = value;
                            _formError = null;
                          });
                        },
                        onScreenTimeChanged: (value) {
                          setState(() {
                            _screenTimeBeforeBedMinutes = value;
                            _formError = null;
                          });
                        },
                        onActivityChanged: (value) {
                          setState(() {
                            _physicalActivity = value;
                            _formError = null;
                          });
                        },
                        onMoodChanged: (value) {
                          setState(() {
                            _mood = value;
                            _formError = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        borderRadius: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(
                              title: 'Optional sleep phases',
                              subtitle:
                                  'Можно оставить пустыми при ручном вводе без источника фаз.',
                            ),
                            const SizedBox(height: 14),
                            _NumberField(
                              controller: _awakeMinutesController,
                              label: 'Awake minutes',
                              suffix: 'мин',
                              validator: _validateOptionalNumber,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _NumberField(
                                    controller: _lightSleepMinutesController,
                                    label: 'Light',
                                    suffix: 'мин',
                                    validator: _validateOptionalNumber,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _NumberField(
                                    controller: _deepSleepMinutesController,
                                    label: 'Deep',
                                    suffix: 'мин',
                                    validator: _validateOptionalNumber,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _NumberField(
                              controller: _remSleepMinutesController,
                              label: 'REM sleep',
                              suffix: 'мин',
                              validator: _validateOptionalNumber,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        borderRadius: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(
                              title: 'Optional physiological metrics',
                              subtitle:
                                  'Пульс и SpO₂ сохраняются только если доступны и введены.',
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _NumberField(
                                    controller: _averageHeartRateController,
                                    label: 'Avg HR',
                                    suffix: 'bpm',
                                    validator: _validateOptionalNumber,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _NumberField(
                                    controller: _nightHeartRateController,
                                    label: 'Night HR',
                                    suffix: 'bpm',
                                    validator: _validateOptionalNumber,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _NumberField(
                              controller: _spo2Controller,
                              label: 'SpO₂',
                              suffix: '%',
                              validator: _validateOptionalNumber,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 240,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Что могло повлиять на сон?',
                        ),
                        validator: (value) {
                          if ((value?.length ?? 0) > 240) {
                            return 'Заметки должны быть до 240 символов.';
                          }

                          return null;
                        },
                      ),
                      if (_formError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _formError!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return GradientButton(
                            label: _controller.isSaving
                                ? 'Сохраняем...'
                                : 'Сохранить запись сна',
                            icon: Icons.check_circle_outline,
                            isLoading: _controller.isSaving,
                            onPressed: _controller.isSaving ? null : _save,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Отмена'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SleepRecordCard extends StatelessWidget {
  const _SleepRecordCard({
    required this.sleepStartValue,
    required this.wakeValue,
    required this.durationValue,
    required this.source,
    required this.onSleepStartPressed,
    required this.onWakePressed,
    required this.onSourceChanged,
  });

  final String sleepStartValue;
  final String wakeValue;
  final String durationValue;
  final SleepDataSource source;
  final VoidCallback onSleepStartPressed;
  final VoidCallback onWakePressed;
  final ValueChanged<SleepDataSource> onSourceChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x224DA8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'SleepRecord',
            subtitle: 'sleepStart, sleepEnd, durationMinutes и source',
          ),
          const SizedBox(height: 14),
          _TimeSelectorRow(
            label: 'Sleep start',
            value: sleepStartValue,
            icon: Icons.bedtime_outlined,
            onPressed: onSleepStartPressed,
          ),
          const SizedBox(height: 12),
          _TimeSelectorRow(
            label: 'Wake time',
            value: wakeValue,
            icon: Icons.wb_sunny_outlined,
            onPressed: onWakePressed,
          ),
          const SizedBox(height: 12),
          _ReadonlyMetricRow(
            label: 'Duration',
            value: durationValue,
            icon: Icons.timelapse_outlined,
          ),
          const SizedBox(height: 18),
          SegmentedButton<SleepDataSource>(
            segments: const [
              ButtonSegment(
                value: SleepDataSource.manual,
                label: Text('Manual'),
                icon: Icon(Icons.edit_outlined),
              ),
              ButtonSegment(
                value: SleepDataSource.wearable,
                label: Text('Wearable'),
                icon: Icon(Icons.watch_outlined),
              ),
            ],
            selected: {source},
            onSelectionChanged: (selection) => onSourceChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

class _BehaviorFactorCard extends StatelessWidget {
  const _BehaviorFactorCard({
    required this.caffeineCupsBeforeSleep,
    required this.screenTimeBeforeBedMinutes,
    required this.physicalActivity,
    required this.mood,
    required this.onCaffeineChanged,
    required this.onScreenTimeChanged,
    required this.onActivityChanged,
    required this.onMoodChanged,
  });

  final int caffeineCupsBeforeSleep;
  final int screenTimeBeforeBedMinutes;
  final PhysicalActivityLevel physicalActivity;
  final SleepMood mood;
  final ValueChanged<int> onCaffeineChanged;
  final ValueChanged<int> onScreenTimeChanged;
  final ValueChanged<PhysicalActivityLevel> onActivityChanged;
  final ValueChanged<SleepMood> onMoodChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'BehaviorFactor',
            subtitle: 'Кофеин, стресс, экран, активность, настроение',
          ),
          const SizedBox(height: 14),
          _CaffeineStepper(
            value: caffeineCupsBeforeSleep,
            onChanged: onCaffeineChanged,
          ),
          const SizedBox(height: 22),
          _MinutesSlider(
            value: screenTimeBeforeBedMinutes,
            onChanged: onScreenTimeChanged,
          ),
          const SizedBox(height: 22),
          _SegmentedSection<PhysicalActivityLevel>(
            title: 'Physical activity',
            valueLabel: _activityLabel(physicalActivity),
            segments: const [
              ButtonSegment(
                value: PhysicalActivityLevel.none,
                label: Text('Нет'),
                icon: Icon(Icons.block_outlined),
              ),
              ButtonSegment(
                value: PhysicalActivityLevel.light,
                label: Text('Легк.'),
                icon: Icon(Icons.directions_walk),
              ),
              ButtonSegment(
                value: PhysicalActivityLevel.moderate,
                label: Text('Сред.'),
                icon: Icon(Icons.fitness_center_outlined),
              ),
              ButtonSegment(
                value: PhysicalActivityLevel.intense,
                label: Text('Выс.'),
                icon: Icon(Icons.local_fire_department),
              ),
            ],
            selected: physicalActivity,
            onChanged: onActivityChanged,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<SleepMood>(
            value: mood,
            decoration: const InputDecoration(
              labelText: 'Mood',
            ),
            dropdownColor: AppColors.surfacePrimary,
            items: SleepMood.values
                .map(
                  (mood) => DropdownMenuItem(
                    value: mood,
                    child: Text(_moodLabel(mood)),
                  ),
                )
                .toList(),
            onChanged: (mood) {
              if (mood != null) {
                onMoodChanged(mood);
              }
            },
          ),
        ],
      ),
    );
  }

  static String _activityLabel(PhysicalActivityLevel activity) {
    return switch (activity) {
      PhysicalActivityLevel.none => 'Нет',
      PhysicalActivityLevel.light => 'Легкая',
      PhysicalActivityLevel.moderate => 'Средняя',
      PhysicalActivityLevel.intense => 'Высокая',
    };
  }

  static String _moodLabel(SleepMood mood) {
    return switch (mood) {
      SleepMood.calm => 'Спокойное',
      SleepMood.tired => 'Усталость',
      SleepMood.stressed => 'Напряжение',
      SleepMood.energized => 'Энергичность',
    };
  }
}

class _TimeSelectorRow extends StatelessWidget {
  const _TimeSelectorRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondaryAccent),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyMetricRow extends StatelessWidget {
  const _ReadonlyMetricRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryAccent.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryAccent),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingSlider extends StatelessWidget {
  const _RatingSlider({
    required this.label,
    required this.value,
    required this.leadingLabel,
    required this.trailingLabel,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String leadingLabel;
  final String trailingLabel;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title: label, value: '$value/10'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: value.toDouble(),
          label: '$value',
          onChanged: (value) => onChanged(value.round()),
        ),
        Row(
          children: [
            Text(
              leadingLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const Spacer(),
            Text(
              trailingLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MinutesSlider extends StatelessWidget {
  const _MinutesSlider({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          title: 'Evening screen time',
          value: '$value мин',
        ),
        Slider(
          min: 0,
          max: 240,
          divisions: 16,
          value: value.toDouble(),
          label: '$value мин',
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

class _CaffeineStepper extends StatelessWidget {
  const _CaffeineStepper({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.coffee_outlined, color: AppColors.secondaryAccent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Кофе перед сном',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value ${_cupsLabel(value)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          _IconStepButton(
            icon: Icons.remove,
            onPressed: value == 0 ? null : () => onChanged(value - 1),
          ),
          const SizedBox(width: 8),
          _IconStepButton(
            icon: Icons.add,
            onPressed: value == 5 ? null : () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  static String _cupsLabel(int value) {
    return switch (value) {
      1 => 'чашка',
      2 || 3 || 4 => 'чашки',
      _ => 'чашек',
    };
  }
}

class _IconStepButton extends StatelessWidget {
  const _IconStepButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(40),
      ),
    );
  }
}

class _SegmentedSection<T extends Object> extends StatelessWidget {
  const _SegmentedSection({
    required this.title,
    required this.valueLabel,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String valueLabel;
  final List<ButtonSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title: title, value: valueLabel),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<T>(
            segments: segments,
            selected: {selected},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.validator,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String? suffix;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
      ),
      validator: validator,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.secondaryAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.secondaryAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
