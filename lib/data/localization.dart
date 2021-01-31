import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocaleBase {
  final Locale locale;

  LocaleBase({
    @required this.locale,
  });

  static LocaleBase of(BuildContext context) {
    return Localizations.of<LocaleBase>(context, LocaleBase);
  }

  static const LocalizationsDelegate<LocaleBase> _delegate =
      _AppLocalizationsDelegate();

  static LocalizationsDelegate<LocaleBase> get delegate => _delegate;

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
    _conversion =
        Localeconversion(Map<String, String>.from(_data['conversion']));
  }

  String get(String key) {
    return _main.getWithNull(key) ?? _conversion.getWithNull(key) ?? '404:$key';
  }
}

class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String get(String key) {
    return getWithNull(key) ?? '404:$key';
  }

  String getWithNull(String key) {
    return _data[key];
  }

  String get sample => _data["sample"];
  String get save => _data["save"];
}

class Localeconversion {
  final Map<String, String> _data;
  Localeconversion(this._data);

  String get(String key) {
    return getWithNull(key) ?? '404:$key';
  }

  String getWithNull(String key) {
    return _data[key];
  }

  String get lengths => _data["lengths"];
  String get areas => _data["areas"];
  String get volumes => _data["volumes"];
  String get meter => _data["meter"];
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<LocaleBase> {
  const _AppLocalizationsDelegate();
  static const Map<String, String> pathes = {'en': 'EN_US', 'de': 'de_DE'};
  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<LocaleBase> load(Locale locale) async {
    LocaleBase loc = LocaleBase(locale: locale);
    await loc.load('locales/${pathes[locale.languageCode]}.json');
    return loc;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<LocaleBase> old) => false;
}
