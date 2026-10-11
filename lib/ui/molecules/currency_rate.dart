import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../atoms/currency_badge.dart';
import '../atoms/price_label.dart';

class CurrencyRateCard extends StatelessWidget {
  final CurrencyRate rate;
  const CurrencyRateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    final c = rate.currency;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurrencyBadge(code: c.code, size: 64),
            const SizedBox(height: 12),
            Text(c.name, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text('1 ${c.code} ='),
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