import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namora/app/app_controller.dart';
import 'package:namora/app/namora_app.dart';
import 'package:namora/core/models/brand_name.dart';
import 'package:namora/core/services/brand_name_generator.dart';
import 'package:namora/core/services/preferences_repository.dart';
import 'package:namora/features/favorites/favorites_page.dart';
import 'package:namora/features/generator/generator_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('generates, favorites, and navigates between core screens',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = AppController(
      repository: MemoryPreferencesRepository(),
      generator: BrandNameGenerator(random: Random(7)),
    );
    await controller.initialize();
    await tester.pumpWidget(NamoraApp(controller: controller));
    await tester.pumpAndSettle();

    final generatorPage = find.byType(GeneratorPage);
    expect(
      find.descendant(of: generatorPage, matching: find.text('Namora')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: generatorPage, matching: find.text('生成灵感')),
      findsOneWidget,
    );
    expect(controller.suggestions, hasLength(6));

    final favoriteName = controller.suggestions.first;
    await tester.tap(
      find.descendant(
        of: generatorPage,
        matching: find.byKey(Key('favorite-${favoriteName.value}')),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.favorites, hasLength(1));

    await tester.tap(find.byKey(const Key('favoritesTab')));
    await tester.pumpAndSettle();
    final favoritesPage = find.byType(FavoritesPage);
    expect(
      find.descendant(
        of: favoritesPage,
        matching: find.text('你的灵感收藏夹还空着'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: favoritesPage,
        matching: find.text(controller.favorites.first.value),
      ),
      findsOneWidget,
    );
  });

  testWidgets('switches between Chinese and English', (tester) async {
    final controller = AppController(
      repository: MemoryPreferencesRepository(),
      generator: BrandNameGenerator(random: Random(9)),
    );
    await controller.initialize();
    await tester.pumpWidget(NamoraApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(GeneratorPage),
        matching: find.byKey(const Key('languageButton')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create names'), findsOneWidget);
    expect(controller.locale.languageCode, 'en');
  });
}

class MemoryPreferencesRepository implements PreferencesRepository {
  List<BrandName> favorites = <BrandName>[];
  List<BrandName> history = <BrandName>[];
  BrandIndustry? industry;
  BrandStyle? style;
  String? languageCode;

  @override
  Future<List<BrandName>> loadFavorites() async => List.of(favorites);

  @override
  Future<List<BrandName>> loadHistory() async => List.of(history);

  @override
  Future<BrandIndustry?> loadIndustry() async => industry;

  @override
  Future<BrandStyle?> loadStyle() async => style;

  @override
  Future<String?> loadLanguageCode() async => languageCode;

  @override
  Future<void> saveFavorites(List<BrandName> values) async {
    favorites = List.of(values);
  }

  @override
  Future<void> saveHistory(List<BrandName> values) async {
    history = List.of(values);
  }

  @override
  Future<void> saveFilters(
    BrandIndustry selectedIndustry,
    BrandStyle selectedStyle,
  ) async {
    industry = selectedIndustry;
    style = selectedStyle;
  }

  @override
  Future<void> saveLanguageCode(String value) async {
    languageCode = value;
  }
}
