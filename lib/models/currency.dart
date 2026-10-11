class Currency {
  final String code;
  final String name;

  const Currency({required this.code, required this.name});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: (json['code'] ?? '').toString().toUpperCase(),
        name: (json['name'] ?? '').toString(),
      );
}

class CurrencyCatalog {
  final List<Currency> currencies;

  const CurrencyCatalog(this.currencies);

  factory CurrencyCatalog.fromJson(Map<String, dynamic> json) {
    final list = json.entries
        .map((e) => Currency.fromJson({'code': e.key, 'name': e.value}))
        .where((c) => c.name.trim().isNotEmpty)
        .toList();
    return CurrencyCatalog(list);
  }
}

class PhpRates {
  final String date;
  final Map<String, double> rates;

  const PhpRates({required this.date, required this.rates});

  factory PhpRates.fromJson(Map<String, dynamic> json) {
    final raw = json['php'];
    if (raw is! Map) {
      throw const FormatException('Missing "php" rates.');
    }
    final rates = <String, double>{};
    raw.forEach((key, value) {
      if (value is num) rates[key.toString().toLowerCase()] = value.toDouble();
    });
    return PhpRates(date: (json['date'] ?? '').toString(), rates: rates);
  }
}

class CurrencyRate {
  final Currency currency;
  final double phpPerUnit;
  final String date;

  const CurrencyRate({
    required this.currency,
    required this.phpPerUnit,
    required this.date,
  });

  String get formattedPrice {
    final digits = phpPerUnit >= 1 ? 2 : (phpPerUnit >= 0.01 ? 4 : 6);
    return '₱${phpPerUnit.toStringAsFixed(digits)}';
  }
}