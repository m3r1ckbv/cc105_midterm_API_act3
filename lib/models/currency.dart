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