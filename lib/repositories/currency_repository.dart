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
  final CurrencyRate rate;
  const RandomCurrencyData(this.rate);
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
  CurrencyCatalog? _catalogCache;

  static const _majorCodes = [
    'usd', 'eur', 'jpy', 'gbp', 'aud', 'cad',
    'chf', 'cny', 'hkd', 'sgd', 'nzd', 'krw', 'inr',
  ];

  Future<CurrencyCatalog> _catalog() async =>
      _catalogCache ??= await _service.fetchCatalog();

Future<List<CurrencyRate>> getRandomMajorCurrencies() async {
  await Future.delayed(const Duration(seconds: 5));

  final catalog = await _catalog();
  final php = await _service.fetchPhpRates();

  final majors = <CurrencyRate>[];
  for (final c in catalog.currencies) {
    final code = c.code.toLowerCase();
    if (!_majorCodes.contains(code)) continue;
    final perPhp = php.rates[code];
    if (perPhp == null || perPhp <= 0) continue;
    majors.add(CurrencyRate(
      currency: c,
      phpPerUnit: 1 / perPhp,
      date: php.date,
    ));
  }
  majors.shuffle(_random);

  final phpRate = catalog.currencies
      .where((c) => c.code.toLowerCase() == 'php')
      .map((c) => CurrencyRate(currency: c, phpPerUnit: 1, date: php.date))
      .toList();

  return [...phpRate, ...majors.take(10 - phpRate.length)]..shuffle(_random);
}

  Future<CurrencyRate> _fetchRandomRate() async {
    final catalog = await _catalog();
    final php = await _service.fetchPhpRates();

    final candidates = catalog.currencies.where((c) {
      final code = c.code.toLowerCase();
      return code != 'php' && (php.rates[code] ?? 0) > 0;
    }).toList();

    if (candidates.isEmpty) {
      throw const ApiException('No currency rates available.');
    }

    final pick = candidates[_random.nextInt(candidates.length)];
    final phpPerForeign = php.rates[pick.code.toLowerCase()]!;
    return CurrencyRate(
      currency: pick,
      phpPerUnit: 1 / phpPerForeign,
      date: php.date,
    );
  }

  Stream<RandomCurrencyState> watchRandomCurrency({
  Duration interval = const Duration(seconds: 5),
  int failEvery = 4,
  }) async* {
    var fetchCount = 0;

    while (true) {
      fetchCount++;
      yield const RandomCurrencyLoading();
      await Future.delayed(const Duration(seconds: 2));

      try {
        if (failEvery > 0 && fetchCount % failEvery == 0) {
          throw const ApiException('Simulated error: failed to fetch currency.');
        }
        yield RandomCurrencyData(await _fetchRandomRate());
      } catch (e) {
        yield RandomCurrencyError(e.toString());
      }

      await Future.delayed(interval);
    }
  }
}