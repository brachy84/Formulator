import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localemain _main;
  Localemain get main => _main;
  Localeconversion _conversion;
  Localeconversion get conversion => _conversion;

  void initAll() {
    _main = Localemain(Map<String, String>.from(_data['main']));
    _conversion = Localeconversion(Map<String, String>.from(_data['conversion']));
  }
}

class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get sample => _data["sample"];
  String get save => _data["save"];
}

class Localeconversion {
  final Map<String, String> _data;
  Localeconversion(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get lengths => _data["lengths"];
  String get areas => _data["areas"];
  String get volumes => _data["volumes"];
  String get meter => _data["meter"];
}

