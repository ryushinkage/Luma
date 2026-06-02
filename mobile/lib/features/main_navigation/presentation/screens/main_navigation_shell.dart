import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../../../home/presentation/screens/home_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    _NavigationTab(
      label: 'Головна',
      title: 'Огляд сну за день',
      description:
          'Тут зʼявляться ваш головний sleep score, сигнал відновлення та наступна корисна дія.',
      actionLabel: 'Додати запис сну',
      icon: Icons.nights_stay_outlined,
      selectedIcon: Icons.nights_stay,
      screen: HomeScreen(),
    ),
    _NavigationTab(
      label: 'Сон',
      title: 'Записи сну',
      description:
          'Історія сну, швидке ручне додавання та деталі записів будуть у цьому розділі.',
      actionLabel: 'Створити перший запис',
      icon: Icons.bedtime_outlined,
      selectedIcon: Icons.bedtime,
    ),
    _NavigationTab(
      label: 'Аналітика',
      title: 'Аналітика сну',
      description:
          'Тут будуть тренди, регулярність, відновлення та попередній перегляд кореляцій звичок.',
      actionLabel: 'Переглянути тренди',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
    ),
    _NavigationTab(
      label: 'AI-коуч',
      title: 'AI-коуч зі сну',
      description:
          'Wellness-рекомендації та тижневі підсумки коучингу зʼявляться після накопичення даних.',
      actionLabel: 'Переглянути інсайти',
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome,
    ),
    _NavigationTab(
      label: 'Профіль',
      title: 'Профіль і налаштування',
      description:
          'Дані користувача, статус підписки, сповіщення та приватність будуть керуватися тут.',
      actionLabel: 'Керувати профілем',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
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
