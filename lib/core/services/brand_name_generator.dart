import 'dart:math';

import 'package:english_words/english_words.dart';

import '../models/brand_name.dart';

class BrandNameGenerator {
  BrandNameGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const _industryWords = <BrandIndustry, List<String>>{
    BrandIndustry.technology: <String>[
      'labs',
      'byte',
      'flow',
      'grid',
      'cloud',
    ],
    BrandIndustry.lifestyle: <String>[
      'living',
      'nest',
      'daily',
      'house',
      'club',
    ],
    BrandIndustry.wellness: <String>[
      'bloom',
      'well',
      'vita',
      'calm',
      'root',
    ],
    BrandIndustry.finance: <String>[
      'capital',
      'ledger',
      'mint',
      'fund',
      'vault',
    ],
    BrandIndustry.creative: <String>[
      'studio',
      'craft',
      'spark',
      'canvas',
      'works',
    ],
  };

  List<BrandName> generate({
    required BrandIndustry industry,
    required BrandStyle style,
    int count = 6,
  }) {
    final results = <BrandName>[];
    final seen = <String>{};

    while (results.length < count) {
      final pair = generateWordPairs(random: _random).first;
      final industryWord = _pick(_industryWords[industry]!);
      final raw = _compose(pair, industryWord, style);
      final value = _pascalCase(raw);
      if (!seen.add(value.toLowerCase())) continue;

      results.add(
        BrandName(
          value: value,
          industry: industry,
          style: style,
          createdAt: DateTime.now(),
        ),
      );
    }
    return results;
  }

  String _compose(WordPair pair, String industryWord, BrandStyle style) {
    switch (style) {
      case BrandStyle.modern:
        return _random.nextBool()
            ? '${pair.first}$industryWord'
            : '${pair.second}$industryWord';
      case BrandStyle.playful:
        final shortWord = pair.first.length <= pair.second.length
            ? pair.first
            : pair.second;
        return '$shortWord${_pick(const <String>['pop', 'joy', 'bee', 'go'])}';
      case BrandStyle.elegant:
        return '${_pick(const <String>['atelier', 'maison', 'lumi', 'vera'])}'
            '${pair.second}';
      case BrandStyle.bold:
        return '${_pick(const <String>['nova', 'prime', 'apex', 'iron'])}'
            '${_random.nextBool() ? pair.first : industryWord}';
    }
  }

  T _pick<T>(List<T> values) => values[_random.nextInt(values.length)];

  String _pascalCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}
