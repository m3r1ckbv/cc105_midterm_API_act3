import 'dart:math';
import '../models/currency.dart';
import '../services/api_services.dart';

sealed class RandomCurrencyState {
  const RandomCurrencyState();
}

class RandomCurrencyLoading extends RandomCurrencyState {
  const RandomCurrencyLoading();
}

class RandomCurrencyData extends RandomCurrencyState {
  final Currency currency;
  const RandomCurrencyData(this.currency);
}

class RandomCurrencyError extends RandomCurrencyState {
  final String message;
  const RandomCurrencyError(this.message);
}

class CurrencyRepository {
  CurrencyRepository({CurrencyApiService? service})
      : _service = service ?? CurrencyApiService();

  final CurrencyApiService _service;
  final _random = Random();

  static const _majorCodes = [
    'usd', 'eur', 'jpy', 'gbp', 'aud', 'cad',
    'chf', 'cny', 'hkd', 'sgd', 'nzd', 'krw', 'inr',
  ];

  /// 10 random major currencies, always including PHP.
  Future<List<Currency>> getRandomMajorCurrencies() async {
    final catalog = await _service.fetchCatalog();

    final majors = catalog.currencies
        .where((c) => _majorCodes.contains(c.code.toLowerCase()))
        .toList()
      ..shuffle(_random);

    final php = catalog.currencies
        .where((c) => c.code.toLowerCase() == 'php')
        .toList();

    final result = [...php, ...majors.take(10 - php.length)]..shuffle(_random);
    return result;
  }

  /// Emits loading -> data/error every [interval]. Errors are emitted as
  /// values (not thrown), so one failed fetch never kills the stream.
  Stream<RandomCurrencyState> watchRandomCurrency({
    Duration interval = const Duration(seconds: 5),
  }) async* {
    while (true) {
      yield const RandomCurrencyLoading();
      try {
        final catalog = await _service.fetchCatalog();
        if (catalog.currencies.isEmpty) {
          yield const RandomCurrencyError('No currencies available.');
        } else {
          final pick =
              catalog.currencies[_random.nextInt(catalog.currencies.length)];
          yield RandomCurrencyData(pick);
        }
      } catch (e) {
        yield RandomCurrencyError(e.toString());
      }
      await Future.delayed(interval);
    }
  }
}