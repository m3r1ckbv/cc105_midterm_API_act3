import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../atoms/currency_badge.dart';
import '../atoms/price_label.dart';

class CurrencyCard extends StatelessWidget {
  final CurrencyRate rate;
  const CurrencyCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    final currency = rate.currency;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurrencyBadge(code: currency.code, size: 64),
            const SizedBox(height: 12),
            Text(currency.name, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text('1 ${currency.code} ='),
            PriceLabel(text: rate.formattedPrice),
            const SizedBox(height: 8),
            Text(
              'Philippine Peso • ${rate.date}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}