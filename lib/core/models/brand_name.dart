import 'dart:convert';

enum BrandIndustry { technology, lifestyle, wellness, finance, creative }

enum BrandStyle { modern, playful, elegant, bold }

class BrandName {
  const BrandName({
    required this.value,
    required this.industry,
    required this.style,
    required this.createdAt,
  });

  final String value;
  final BrandIndustry industry;
  final BrandStyle style;
  final DateTime createdAt;

  String encode() => jsonEncode(<String, Object>{
        'value': value,
        'industry': industry.name,
        'style': style.name,
        'createdAt': createdAt.toIso8601String(),
      });

  static BrandName? decode(String source) {
    try {
      final json = jsonDecode(source) as Map<String, dynamic>;
      return BrandName(
        value: json['value'] as String,
        industry: BrandIndustry.values.byName(json['industry'] as String),
        style: BrandStyle.values.byName(json['style'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } on Object {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is BrandName && other.value.toLowerCase() == value.toLowerCase();

  @override
  int get hashCode => value.toLowerCase().hashCode;
}
