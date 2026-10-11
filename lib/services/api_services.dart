import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

class CurrencyApiService {
  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static final _uri = Uri.parse(
    'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json',
  );
  static const _timeout = Duration(seconds: 10);

  Future<CurrencyCatalog> fetchCatalog() async {
    try {
      final response = await _client.get(_uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException('Server error (${response.statusCode}).');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Unexpected response format.');
      }
      return CurrencyCatalog.fromJson(decoded);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on FormatException {
      throw const ApiException('Received invalid data from the server.');
    } catch (_) {
      throw const ApiException('No connection. Check your internet and retry.');
    }
  }
}