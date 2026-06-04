import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/data/repositories/mock_profile_repository.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  late final List<_NavigationTab> _tabs = [
    const _NavigationTab(
      label: 'Главная',
      title: 'Обзор сна за день',
      description:
          'Здесь будет главный sleep score, сигнал восстановления и следующая полезная sleep-coaching задача.',
      actionLabel: 'Добавить запись сна',
      icon: Icons.nights_stay_outlined,
      selectedIcon: Icons.nights_stay,
      screen: HomeScreen(),
    ),
    const _NavigationTab(
      label: 'Сон',
      title: 'Записи сна',
      description:
          'История сна, быстрое ручное добавление и детали записей будут в этом разделе.',
      actionLabel: 'Создать первую запись',
      icon: Icons.bedtime_outlined,
      selectedIcon: Icons.bedtime,
    ),
    const _NavigationTab(
      label: 'Аналитика',
      title: 'Аналитика сна',
      description:
          'Тренды, регулярность, восстановление и предварительный просмотр корреляций привычек появятся здесь.',
      actionLabel: 'Посмотреть тренды',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
    ),
    const _NavigationTab(
      label: 'AI-коуч',
      title: 'AI-коуч сна',
      description:
          'Wellness-рекомендации и недельные итоги sleep-coaching появятся после накопления данных.',
      actionLabel: 'Посмотреть инсайты',
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome,
    ),
    _NavigationTab(
      label: 'Профиль',
      title: 'Профиль и настройки',
      description:
          'Данные пользователя, статус подписки, уведомления и приватность управляются здесь.',
      actionLabel: 'Открыть профиль',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      screen: ProfileScreen(
        controller: ProfileController(
          repository: const MockProfileRepository(),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTab = _tabs[_selectedIndex];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(selectedTab.label),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.backgroundGlow),
        child: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              for (final tab in _tabs)
                tab.screen ?? _NavigationPlaceholderScreen(tab: tab),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                for (final tab in _tabs)
                  NavigationDestination(
                    icon: Icon(tab.icon),
                    selectedIcon: Icon(tab.selectedIcon),
                    label: tab.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationPlaceholderScreen extends StatelessWidget {
  const _NavigationPlaceholderScreen({
    required this.tab,
  });

  final _NavigationTab tab;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: EmptyState(
            icon: tab.selectedIcon,
            title: tab.title,
            description: tab.description,
            actionLabel: tab.actionLabel,
            onActionPressed: () {},
          ),
        ),
      ),
    );
  }
}

class _NavigationTab {
  const _NavigationTab({
    required this.label,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.icon,
    required this.selectedIcon,
    this.screen,
  });

  final String label;
  final String title;
  final String description;
  final String actionLabel;
  final IconData icon;
  final IconData selectedIcon;
  final Widget? screen;
}
