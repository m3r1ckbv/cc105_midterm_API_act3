import 'package:flutter/material.dart';
import '../../repositories/currency_repository.dart';
import '../atoms/loading_spinner.dart';
import '../molecules/currency_card.dart';
import '../molecules/message_view.dart';

class RandomCurrencyView extends StatelessWidget {
  final RandomCurrencyState state;
  const RandomCurrencyView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      RandomCurrencyLoading() => const LoadingSpinner(),
      RandomCurrencyError(:final message) => MessageView(
          icon: Icons.wifi_off,
          message: '$message\nRetrying automatically in 5 seconds…',
        ),
      RandomCurrencyData(:final currency) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CurrencyCard(currency: currency),
          ),
        ),
    };
  }
}