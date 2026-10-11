import 'package:flutter/material.dart';
import '../../repositories/currency_repository.dart';
import '../atoms/loading_spinner.dart';
import '../organisms/random_currency_view.dart';
import '../templates/page_template.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  late final Stream<RandomCurrencyState> _stream;

  @override
  void initState() {
    super.initState();
    _stream = CurrencyRepository().watchRandomCurrency().asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Random Currency (Stream)',
      body: StreamBuilder<RandomCurrencyState>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingSpinner();
          return RandomCurrencyView(state: snapshot.data!);
        },
      ),
    );
  }
}