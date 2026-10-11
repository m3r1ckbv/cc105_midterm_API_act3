import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../../repositories/currency_repository.dart';
import '../atoms/loading_spinner.dart';
import '../molecules/message_view.dart';
import '../organisms/currency_list.dart';
import '../templates/page_template.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  final _repo = CurrencyRepository();
  late Future<List<CurrencyRate>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getRandomMajorCurrencies();
  }

  void _retry() {
    setState(() => _future = _repo.getRandomMajorCurrencies());
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Major Currencies (Future)',
      body: FutureBuilder<List<CurrencyRate>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingSpinner();
          }
          if (snapshot.hasError) {
            return MessageView(
              icon: Icons.error_outline,
              message: snapshot.error.toString(),
              actionLabel: 'Retry',
              onAction: _retry,
            );
          }
          final data = snapshot.data ?? const [];
          if (data.isEmpty) {
            return const MessageView(
              icon: Icons.inbox_outlined,
              message: 'No currencies to show.',
            );
          }
          return CurrencyList(rates: data);
        },
      ),
    );
  }
}