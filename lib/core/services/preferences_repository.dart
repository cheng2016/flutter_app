import 'package:shared_preferences/shared_preferences.dart';

import '../models/brand_name.dart';

abstract interface class PreferencesRepository {
  Future<List<BrandName>> loadFavorites();
  Future<List<BrandName>> loadHistory();
  Future<BrandIndustry?> loadIndustry();
  Future<BrandStyle?> loadStyle();
  Future<String?> loadLanguageCode();
  Future<void> saveFavorites(List<BrandName> values);
  Future<void> saveHistory(List<BrandName> values);
  Future<void> saveFilters(BrandIndustry industry, BrandStyle style);
  Future<void> saveLanguageCode(String languageCode);
}

class LocalPreferencesRepository implements PreferencesRepository {
  LocalPreferencesRepository([SharedPreferencesAsync? preferences])
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _favoritesKey = 'favorites';
  static const _historyKey = 'history';
  static const _industryKey = 'industry';
  static const _styleKey = 'style';
  static const _languageKey = 'language';

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<BrandName>> loadFavorites() => _loadNames(_favoritesKey);

  @override
  Future<List<BrandName>> loadHistory() => _loadNames(_historyKey);

  Future<List<BrandName>> _loadNames(String key) async {
    final encoded = await _preferences.getStringList(key) ?? const <String>[];
    return encoded
        .map(BrandName.decode)
        .whereType<BrandName>()
        .toList(growable: false);
  }

  @override
  Future<BrandIndustry?> loadIndustry() async {
    final value = await _preferences.getString(_industryKey);
    return _tryByName(BrandIndustry.values, value);
  }

  @override
  Future<BrandStyle?> loadStyle() async {
    final value = await _preferences.getString(_styleKey);
    return _tryByName(BrandStyle.values, value);
  }

  T? _tryByName<T extends Enum>(List<T> values, String? name) {
    if (name == null) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  @override
  Future<String?> loadLanguageCode() => _preferences.getString(_languageKey);

  @override
  Future<void> saveFavorites(List<BrandName> values) =>
      _saveNames(_favoritesKey, values);

  @override
  Future<void> saveHistory(List<BrandName> values) =>
      _saveNames(_historyKey, values);

  Future<void> _saveNames(String key, List<BrandName> values) =>
      _preferences.setStringList(
        key,
        values.map((item) => item.encode()).toList(growable: false),
      );

  @override
  Future<void> saveFilters(BrandIndustry industry, BrandStyle style) async {
    await Future.wait(<Future<void>>[
      _preferences.setString(_industryKey, industry.name),
      _preferences.setString(_styleKey, style.name),
    ]);
  }

  @override
  Future<void> saveLanguageCode(String languageCode) =>
      _preferences.setString(_languageKey, languageCode);
}
