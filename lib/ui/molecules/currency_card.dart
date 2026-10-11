import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../atoms/currency_badge.dart';

class CurrencyCard extends StatelessWidget {
  final Currency currency;
  const CurrencyCard({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CurrencyBadge(code: currency.code),
        title: Text(currency.name),
        subtitle: Text(currency.code),
      ),
    );
  }
}