import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/models/brand_name.dart';
import '../core/services/brand_name_generator.dart';
import '../core/services/preferences_repository.dart';

class AppController extends ChangeNotifier {
  AppController({
    required PreferencesRepository repository,
    BrandNameGenerator? generator,
  })  : _repository = repository,
        _generator = generator ?? BrandNameGenerator();

  final PreferencesRepository _repository;
  final BrandNameGenerator _generator;

  final List<BrandName> _suggestions = <BrandName>[];
  final List<BrandName> _favorites = <BrandName>[];
  final List<BrandName> _history = <BrandName>[];

  BrandIndustry _industry = BrandIndustry.technology;
  BrandStyle _style = BrandStyle.modern;
  Locale _locale = const Locale('zh');
  int _navigationIndex = 0;
  bool _isGenerating = false;

  List<BrandName> get suggestions => List.unmodifiable(_suggestions);
  List<BrandName> get favorites => List.unmodifiable(_favorites);
  List<BrandName> get history => List.unmodifiable(_history);
  BrandIndustry get industry => _industry;
  BrandStyle get style => _style;
  Locale get locale => _locale;
  int get navigationIndex => _navigationIndex;
  bool get isGenerating => _isGenerating;

  Future<void> initialize() async {
    final values = await Future.wait<Object?>(<Future<Object?>>[
      _repository.loadFavorites(),
      _repository.loadHistory(),
      _repository.loadIndustry(),
      _repository.loadStyle(),
      _repository.loadLanguageCode(),
    ]);
    _favorites
      ..clear()
      ..addAll(values[0]! as List<BrandName>);
    _history
      ..clear()
      ..addAll(values[1]! as List<BrandName>);
    _industry = values[2] as BrandIndustry? ?? _industry;
    _style = values[3] as BrandStyle? ?? _style;
    _locale = Locale(values[4] as String? ?? 'zh');
    _replaceSuggestions();
    notifyListeners();
  }

  Future<void> generate({bool animate = true}) async {
    if (_isGenerating) return;
    _isGenerating = true;
    notifyListeners();
    if (animate) {
      await Future<void>.delayed(const Duration(milliseconds: 320));
    }
    _replaceSuggestions();
    _isGenerating = false;
    notifyListeners();
  }

  void _replaceSuggestions() {
    final generated = _generator.generate(
      industry: _industry,
      style: _style,
    );
    _suggestions
      ..clear()
      ..addAll(generated);
    _history
      ..removeWhere((item) => generated.contains(item))
      ..insertAll(0, generated);
    if (_history.length > 60) {
      _history.removeRange(60, _history.length);
    }
    unawaited(_repository.saveHistory(_history));
  }

  void selectIndustry(BrandIndustry value) {
    if (_industry == value) return;
    _industry = value;
    _saveFiltersAndRegenerate();
  }

  void selectStyle(BrandStyle value) {
    if (_style == value) return;
    _style = value;
    _saveFiltersAndRegenerate();
  }

  void _saveFiltersAndRegenerate() {
    notifyListeners();
    unawaited(_repository.saveFilters(_industry, _style));
    unawaited(generate());
  }

  bool isFavorite(BrandName value) => _favorites.contains(value);

  bool toggleFavorite(BrandName value) {
    final wasFavorite = _favorites.remove(value);
    if (!wasFavorite) {
      _favorites.insert(0, value);
    }
    notifyListeners();
    unawaited(_repository.saveFavorites(_favorites));
    return !wasFavorite;
  }

  void selectNavigation(int index) {
    if (_navigationIndex == index) return;
    _navigationIndex = index;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
    unawaited(_repository.saveHistory(_history));
  }

  void toggleLanguage() {
    _locale = Locale(_locale.languageCode == 'zh' ? 'en' : 'zh');
    notifyListeners();
    unawaited(_repository.saveLanguageCode(_locale.languageCode));
  }
}
