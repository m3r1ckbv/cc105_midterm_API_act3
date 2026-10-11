import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../templates/currency_card.dart';

class CurrencyList extends StatelessWidget {
  final List<CurrencyRate> rates;
  const CurrencyList({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: rates.length,
      itemBuilder: (_, i) => CurrencyCard(rate: rates[i]),
    );
  }
}