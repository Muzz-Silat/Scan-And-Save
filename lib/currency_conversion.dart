import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = '96fca3547b7a46d29ce6e7e12be269aa';

  Future<double> fetchExchangeRate(
      String fromCurrency, String toCurrency) async {
    final url = Uri.parse(
        'https://openexchangerates.org/api/latest.json?app_id=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final rates = json.decode(response.body)['rates'];
      final fromRate = rates[fromCurrency];
      final toRate = rates[toCurrency];
      return toRate / fromRate;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  Future<double> convertCurrency(
      double amount, String fromCurrency, String toCurrency) async {
    final currencyService = CurrencyService();
    double rate =
        await currencyService.fetchExchangeRate(fromCurrency, toCurrency);
    return amount * rate;
  }
}
