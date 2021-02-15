import 'dart:io';

import 'package:all_the_formulars/main.dart';
import 'package:http/http.dart' as http;

// http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
class WebData {
  static Future<http.Response> fetchData(String url) async {
    if (await hasInternet()) {
      hasInternetConnection = true;
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Printing webdata...');
        //print(response.body);
        return response;
      } else {
        throw Exception('Failed to load data from $url');
      }
    }
    throw Exception('Is not connected to Internet');
  }

  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Connected to Internet');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('No Internet connection!');
      return false;
    }
  }
}
