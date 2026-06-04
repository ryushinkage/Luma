import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../../domain/entities/auth_onboarding_draft.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

enum _AuthFlowStep {
  welcome,
  loginEmailPassword,
  registerEmailPassword,
  registrationSleepWindow,
  registrationGoal,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.controller,
    super.key,
  });

  final AuthController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _goalFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _goalController = TextEditingController();

  _AuthFlowStep _step = _AuthFlowStep.welcome;
  TimeOfDay _usualSleepTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _usualWakeTime = const TimeOfDay(hour: 7, minute: 0);

  AuthController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleAuthStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _goalController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleAuthStateChanged() {
    if (!mounted) {
      return;
    }

    final state = _controller.state;

    if (state.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }

    if (state.isRegistered &&
        _step.index < _AuthFlowStep.registrationSleepWindow.index) {
      setState(() {
        _step = _AuthFlowStep.registrationSleepWindow;
      });
      return;
    }

    if (state.isOnboardingComplete) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  Future<void> _submitEmailPassword({
    required bool isRegistration,
  }) async {
    if (!_emailFormKey.currentState!.validate()) {
      return;
    }

    if (isRegistration) {
      await _controller.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      return;
    }

    await _controller.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _completeRegistrationOnboarding() async {
    if (!_goalFormKey.currentState!.validate()) {
      return;
    }

    await _controller.completeOnboarding(
      AuthOnboardingDraft(
        usualSleepTimeMinutes: _minutesFromTime(_usualSleepTime),
        usualWakeTimeMinutes: _minutesFromTime(_usualWakeTime),
        improvementGoal: _goalController.text.trim(),
      ),
    );
  }

  Future<void> _selectTime({
    required bool isSleepTime,
  }) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: isSleepTime ? _usualSleepTime : _usualWakeTime,
      helpText: isSleepTime ? 'Когда обычно ложитесь?' : 'Когда обычно встаете?',
      cancelText: 'Отмена',
      confirmText: 'Готово',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      if (isSleepTime) {
        _usualSleepTime = selected;
      } else {
        _usualWakeTime = selected;
      }
    });
  }

  void _goTo(_AuthFlowStep step) {
    _controller.resetError();
    setState(() {
      _step = step;
    });
  }

  int _minutesFromTime(TimeOfDay time) {
    return time.hour * Duration.minutesPerHour + time.minute;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.backgroundGlow),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final state = _controller.state;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AuthHero(step: _step),
                        const SizedBox(height: 20),
                        _buildStepCard(state),
                        if (state.status == AuthStatus.failure) ...[
                          const SizedBox(height: 14),
                          _ErrorText(message: state.errorMessage),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(AuthState state) {
    return switch (_step) {
      _AuthFlowStep.welcome => _WelcomeCard(
          onLoginPressed: () => _goTo(_AuthFlowStep.loginEmailPassword),
          onRegisterPressed: () => _goTo(_AuthFlowStep.registerEmailPassword),
        ),
      _AuthFlowStep.loginEmailPassword => _EmailPasswordCard(
          title: 'Вход по email',
          description: 'Введите почту и пароль от существующего аккаунта.',
          formKey: _emailFormKey,
          emailController: _emailController,
          passwordController: _passwordController,
          isLoading: state.isLoading,
          submitLabel: state.isLoading ? 'Проверяем...' : 'Войти',
          onSubmit: () => _submitEmailPassword(isRegistration: false),
          onBackPressed: () => _goTo(_AuthFlowStep.welcome),
        ),
      _AuthFlowStep.registerEmailPassword => _EmailPasswordCard(
          title: 'Регистрация по email',
          description: 'Создайте аккаунт, затем укажите цель и обычное окно сна.',
          formKey: _emailFormKey,
          emailController: _emailController,
          passwordController: _passwordController,
          isLoading: state.isLoading,
          submitLabel: state.isLoading ? 'Создаем...' : 'Зарегистрироваться',
          onSubmit: () => _submitEmailPassword(isRegistration: true),
          onBackPressed: () => _goTo(_AuthFlowStep.welcome),
        ),
      _AuthFlowStep.registrationSleepWindow => _SleepWindowRegistrationCard(
          sleepTime: _formatTime(_usualSleepTime),
          wakeTime: _formatTime(_usualWakeTime),
          onSleepTimePressed: () => _selectTime(isSleepTime: true),
          onWakeTimePressed: () => _selectTime(isSleepTime: false),
          onNextPressed: () => _goTo(_AuthFlowStep.registrationGoal),
        ),
      _AuthFlowStep.registrationGoal => _GoalRegistrationCard(
          formKey: _goalFormKey,
          goalController: _goalController,
          isLoading: state.status == AuthStatus.completingOnboarding,
          onBackPressed: () => _goTo(_AuthFlowStep.registrationSleepWindow),
          onFinishPressed: _completeRegistrationOnboarding,
        ),
    };
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({
    required this.step,
  });

  final _AuthFlowStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRegistrationDetails =
        step.index >= _AuthFlowStep.registrationSleepWindow.index;

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.primary,
            boxShadow: const [
              BoxShadow(
                color: Color(0x337C5CFF),
                blurRadius: 32,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: const SizedBox.square(
            dimension: 72,
            child: Icon(
              Icons.shield_moon_outlined,
              color: AppColors.textPrimary,
              size: 34,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          isRegistrationDetails ? 'Настройка профиля сна' : 'Sleep Analytics',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          isRegistrationDetails
              ? 'Эти данные нужны только при регистрации, чтобы подготовить персональную аналитику.'
              : 'AI-powered sleep analytics, recovery insights and personalized sleep coaching.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });

  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x267C5CFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StepLabel(label: 'Аккаунт'),
          const SizedBox(height: 12),
          Text(
            'Войдите в существующий аккаунт или создайте новый профиль сна.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          GradientButton(
            label: 'Войти',
            icon: Icons.login,
            onPressed: onLoginPressed,
          ),
          const SizedBox(height: 12),
          _SecondaryActionButton(
            label: 'Регистрация',
            icon: Icons.person_add_outlined,
            onPressed: onRegisterPressed,
          ),
          const SizedBox(height: 14),
          Text(
            'AI-инсайты являются wellness-рекомендациями и не заменяют медицинскую консультацию.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmailPasswordCard extends StatelessWidget {
  const _EmailPasswordCard({
    required this.title,
    required this.description,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.submitLabel,
    required this.onSubmit,
    required this.onBackPressed,
  });

  final String title;
  final String description;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String submitLabel;
  final VoidCallback onSubmit;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepLabel(label: title),
            const SizedBox(height: 10),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Почта',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';

                if (!text.contains('@')) {
                  return 'Введите email.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Введите пароль.';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            GradientButton(
              label: submitLabel,
              icon: Icons.login,
              isLoading: isLoading,
              onPressed: isLoading ? null : onSubmit,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: isLoading ? null : onBackPressed,
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepWindowRegistrationCard extends StatelessWidget {
  const _SleepWindowRegistrationCard({
    required this.sleepTime,
    required this.wakeTime,
    required this.onSleepTimePressed,
    required this.onWakeTimePressed,
    required this.onNextPressed,
  });

  final String sleepTime;
  final String wakeTime;
  final VoidCallback onSleepTimePressed;
  final VoidCallback onWakeTimePressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StepLabel(label: 'Регистрация · шаг 1 из 2'),
          const SizedBox(height: 12),
          const _QuestionTitle(
            title:
                'Когда вы обычно ложитесь спать и во сколько обычно встаете?',
            subtitle:
                'Эти данные нужны для первичной оценки регулярности режима.',
          ),
          const SizedBox(height: 18),
          _TimeChoiceRow(
            label: 'Обычно ложусь',
            value: sleepTime,
            icon: Icons.bedtime_outlined,
            onPressed: onSleepTimePressed,
          ),
          const SizedBox(height: 12),
          _TimeChoiceRow(
            label: 'Обычно встаю',
            value: wakeTime,
            icon: Icons.wb_sunny_outlined,
            onPressed: onWakeTimePressed,
          ),
          const SizedBox(height: 22),
          GradientButton(
            label: 'Далее',
            icon: Icons.arrow_forward,
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }
}

class _GoalRegistrationCard extends StatelessWidget {
  const _GoalRegistrationCard({
    required this.formKey,
    required this.goalController,
    required this.isLoading,
    required this.onBackPressed,
    required this.onFinishPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController goalController;
  final bool isLoading;
  final VoidCallback onBackPressed;
  final VoidCallback onFinishPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _StepLabel(label: 'Регистрация · шаг 2 из 2'),
            const SizedBox(height: 12),
            const _QuestionTitle(
              title: 'Какая цель по улучшению сна сейчас главная?',
              subtitle:
                  'Например: регулярность, восстановление, меньше sleep debt или спокойнее отход ко сну.',
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: goalController,
              minLines: 3,
              maxLines: 4,
              maxLength: 160,
              decoration: const InputDecoration(
                labelText: 'Цель',
                hintText: 'Что хотите улучшить?',
              ),
              validator: (value) {
                if ((value?.trim().length ?? 0) < 4) {
                  return 'Опишите цель коротко.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SecondaryActionButton(
                    label: 'Назад',
                    icon: Icons.arrow_back,
                    onPressed: isLoading ? null : onBackPressed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: isLoading ? 'Сохраняем...' : 'Готово',
                    icon: Icons.check_circle_outline,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onFinishPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChoiceRow extends StatelessWidget {
  const _TimeChoiceRow({
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.glassSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.secondaryAccent,
            fontWeight: FontWeight.w800,
          ),
      textAlign: TextAlign.center,
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({
    required this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message ?? 'Не удалось выполнить действие.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.danger,
          ),
      textAlign: TextAlign.center,
    );
  }
}
