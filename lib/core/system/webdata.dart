import 'package:http/http.dart' as http;

// http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
class WebData {

  static Map<String, double> exchangeRates = {'EUR' : 1.0};
  static String date = '';

  static Future<http.Response> fetchData(String url) async {
    final response = await http.get(url);

    if(response.statusCode == 200) {
      //print('Printing webdata...');
      //print(response.body);
      return response;
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  static initCurrencyExchange() async {
    http.Response response = await fetchData('http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml');
    String rawXml = response.body;

    int timeIndex = rawXml.indexOf('time=') + 6;
    date = rawXml.substring(timeIndex, timeIndex + 10);
    // creates a list of currencies like 'currency='USD' rate='1.2281'/>'
    List<String> currencies = rawXml.split('<Cube ').where((element) => element.startsWith('currency=')).toList();

    currencies.forEach((currency) {
      int start = currency.indexOf('=') + 2;
      String curr = currency.substring(start, start + 3);
      String val = currency.substring(currency.lastIndexOf('=') + 2, currency.lastIndexOf('\''));
      exchangeRates[curr] = double.parse(val);
    });

    print('Exchange rate map from the $date:');
    print('  $exchangeRates');
  }
}

