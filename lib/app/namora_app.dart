import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/localization/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/favorites/favorites_page.dart';
import '../features/generator/generator_page.dart';
import '../features/history/history_page.dart';
import 'app_controller.dart';

class NamoraApp extends StatelessWidget {
  const NamoraApp({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Namora',
          locale: controller.locale,
          supportedLocales: const <Locale>[Locale('zh'), Locale('en')],
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: _AppShell(controller: controller),
        ),
      );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      body: IndexedStack(
        index: controller.navigationIndex,
        children: <Widget>[
          GeneratorPage(controller: controller),
          FavoritesPage(controller: controller),
          HistoryPage(controller: controller),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.navigationIndex,
        onDestinationSelected: controller.selectNavigation,
        destinations: <NavigationDestination>[
          NavigationDestination(
            key: const Key('discoverTab'),
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: strings.discover,
          ),
          NavigationDestination(
            key: const Key('favoritesTab'),
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon: const Icon(Icons.favorite_rounded),
            label: strings.favorites,
          ),
          NavigationDestination(
            key: const Key('historyTab'),
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history_rounded),
            label: strings.history,
          ),
        ],
      ),
    );
  }
}
