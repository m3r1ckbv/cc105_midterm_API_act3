import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../molecules/currency_card.dart';

class CurrencyList extends StatelessWidget {
  final List<Currency> currencies;
  const CurrencyList({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: currencies.length,
      itemBuilder: (_, i) => CurrencyCard(currency: currencies[i]),
    );
  }
}