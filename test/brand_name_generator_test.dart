import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:namora/core/models/brand_name.dart';
import 'package:namora/core/services/brand_name_generator.dart';

void main() {
  test('generates unique names with selected metadata', () {
    final generator = BrandNameGenerator(random: Random(42));

    final names = generator.generate(
      industry: BrandIndustry.creative,
      style: BrandStyle.bold,
      count: 12,
    );

    expect(names, hasLength(12));
    expect(names.map((name) => name.value).toSet(), hasLength(12));
    expect(
      names.every((name) => name.industry == BrandIndustry.creative),
      isTrue,
    );
    expect(names.every((name) => name.style == BrandStyle.bold), isTrue);
  });

  test('brand name serialization round-trips', () {
    final original = BrandName(
      value: 'NovaSpark',
      industry: BrandIndustry.technology,
      style: BrandStyle.modern,
      createdAt: DateTime.utc(2026, 8, 10),
    );

    final decoded = BrandName.decode(original.encode());
    expect(decoded?.value, original.value);
    expect(decoded?.industry, original.industry);
    expect(decoded?.style, original.style);
    expect(decoded?.createdAt, original.createdAt);
    expect(BrandName.decode('not json'), isNull);
  });
}
