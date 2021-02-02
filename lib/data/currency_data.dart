import 'package:all_the_formulars/utils.dart';
import 'package:http/http.dart' as http;
import 'package:all_the_formulars/data/webdata.dart';

class CurrencyData {
  static Map<String, double> exchangeRates = {'EUR': 1.0};
  static String date = '';
  static String lastUpdated = '';

  static initCurrencyExchange() async {
    if (date == '') {
      http.Response response;
      try {
        response = await WebData.fetchData(
            'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml');
      } catch (Exception) {
        return;
      }

      String rawXml = response.body;

      int timeIndex = rawXml.indexOf('time=') + 6;
      date = rawXml.substring(timeIndex, timeIndex + 10);

      // creates a list of currencies like 'currency='USD' rate='1.2281'/>'
      List<String> currencies = rawXml
          .split('<Cube ')
          .where((element) => element.startsWith('currency='))
          .toList();

      currencies.forEach((currency) {
        int start = currency.indexOf('=') + 2;
        String curr = currency.substring(start, start + 3);
        String val = currency.substring(
            currency.lastIndexOf('=') + 2, currency.lastIndexOf('\''));
        exchangeRates[curr] = double.parse(val);
      });

      final _parts = DateTime.now().toString().split(':');
      lastUpdated = _parts[0] + ':' + _parts[1];

      print('Exchange rate map from the $date:');
      print('  $exchangeRates');
    }
  }

  static double convertTo(
      String startCurrency, String endCurrency, double value) {
    return Utils.dp(
        convertFromEur(endCurrency, convertToEur(startCurrency, value)), 4);
  }

  static double convertToEur(String startCurrency, double value) {
    if (exchangeRates.containsKey(startCurrency)) {
      return value / exchangeRates[startCurrency];
    } else {
      print('Error while converting from $startCurrency to EUR');
      return 0;
    }
  }

  static double convertFromEur(String endCurrency, double value) {
    if (exchangeRates.containsKey(endCurrency)) {
      return value * exchangeRates[endCurrency];
    } else {
      print('Error while converting from EUR to $endCurrency');
      return 0;
    }
  }
}
