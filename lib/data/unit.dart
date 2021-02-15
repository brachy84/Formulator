import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Units {
  static List<Unit> _units = [];
  static List<Unit> get all => _units;
  static void _add(Unit unit) => _units.add(unit);

  static Unit getFromShort(String short) {
    if (short == '') return NONE;
    return all.firstWhere((unit) {
      return unit.keys
              .firstWhere((def) => def[0] == short, orElse: () => [])
              .length ==
          2;
    });
  }

  static final Unit NONE = Unit(defaultValue: '', convertValues: {});

  static final Unit lengths = Unit(defaultValue: 'm', convertValues: {
    ['mm', 'millimeter']: 1000,
    ['cm', 'centimeter']: 100,
    ['dm', 'decimeter']: 10,
    ['m', 'meter']: 1,
    ['km', 'kilometer']: 0.001,
    ['mile', 'mile']: 0.000621371,
    ['foot', 'foot']: 3.28084,
    ['in', 'inch']: 39.3701,
    ['yd', 'yard']: 1.093613298,
    ['sm', 'seemile']: 0.0005399568
  });

  static final Unit area = Unit(defaultValue: 'm²', convertValues: {
    ['km²', 'sq_kilometer']: 0.000001,
    ['m²', 'sq_meter']: 1,
    ['cm²', 'sq_centimeter']: 10000,
    ['mm²', 'sq_millimeter']: 1000000,
    ['mile²', 'sq_mile']: 0.000000386102,
    ['foot²', 'sq_foot']: 10.7639104167,
    ['inch²', 'sq_inch']: 1550
  });
  static final Unit volume = Unit(defaultValue: 'm³', convertValues: {
    ['km³', 'cu_kilometer']: 0.000000001,
    ['m³', 'cu_meter']: 1,
    ['cm³', 'cu_centimeter']: 1000000,
    ['mm³', 'cu_millimeter']: 1000000000,
    //'mile³': 0.000621371,
    ['foot³', 'cu_foot']: 35.3147,
    ['inch³', 'cu_inch']: 61023,
  });

  static final Unit weight = Unit(defaultValue: 'kg', convertValues: {
    ['mg', 'milli_gram']: 1000000,
    ['g', 'gram']: 1000,
    ['kg', 'kilo_gram']: 1,
    ['t', 'ton']: 0.001,
    ['lb', 'pound']: 2.20462,
    ['oz', 'ounce']: 35.274,
  });

  static final Unit temperatur = Unit(defaultValue: '°C', convertCallbacks: {
    ['°C', 'celsius']: [(val) => val, (val) => val],
    ['°F', 'fahrenheit']: [
      (val) => (val - 32) * 5 / 9,
      (val) => val * 9 / 5 + 32
    ],
    ['K', 'kelvin']: [(val) => val - 273.15, (val) => val + 273.15],
    ['°Ra', 'rankine']: [
      (val) => val * 5 / 9 - 273.15,
      (val) => val * 1.8 + 459.67
    ],
    ['°Ré', 'reaumur']: [(val) => val * 1.25, (val) => val * 0.8],
    ['°Rø', 'romer']: [
      (val) => (val - 7.5) * 40 / 21,
      (val) => val * 21 / 40 + 7.5
    ],
    ['°De', 'delisle']: [
      (val) => (100 - val) * 2 / 3,
      (val) => (100 - val) * 1.5
    ],
    ['°N', 'd_newton']: [(val) => val * 100 / 33, (val) => val * 0.33],
  });

  static final Unit speed = Unit(defaultValue: 'km/h', convertValues: {
    ['km/h']: 1,
    ['m/s']: 0.277777777778,
    ['mile/h']: 0.621371,
    ['foot/s']: 0.911344,
    ['kn', 'knot']: 0.539957,
  });

  static final Unit acceleration = Unit(defaultValue: 'm/s²', convertValues: {
    ['m/s²']: 1,
    ['Gal']: 0.01,
  });

  static final Unit angle = Unit(defaultValue: '°', convertValues: {
    ['°', 'degree']: 1,
    ['gon', 'gon']: 0.9,
    ['min', 'minute']: 60,
    ['s', 'second']: 3600
  });

  static final Unit time = Unit(defaultValue: 'min', convertValues: {
    ['ms', 'millisecond']: 3600000,
    ['s', 'second']: 3600,
    ['min', 'minute']: 60,
    ['h', 'hour']: 1,
    ['d', 'day']: 1 / 24,
    ['7d', 'week']: 1 / 24 / 7,
    ['y', 'year']: 1 / 365.2425
  });
  //pressure
  static final Unit pressure = Unit(defaultValue: 'bar', convertValues: {
    ['bar', 'bar']: 1,
    ['Pa', 'pascal']: 0.00001,
    ['N/mm²', 'n_mm2']: 10,
    ['N/cm²', 'n_cm2']: 0.1,
    ['N/m²', 'n_m2']: 0.00001,
  });
  // force
  static final Unit force = Unit(defaultValue: 'N', convertValues: {
    ['N', 'newton']: 1,
    ['kN', 'kilonewton']: 0.001,
  });

  static final Unit data = Unit(defaultValue: 'mbit', convertValues: {
    ['bit', 'bit']: 1000000,
    ['kbit', 'kilobit']: 1000,
    ['mbit', 'megabit']: 1,
    ['gbit', 'gigabit']: 0.001,
    ['tbit', 'terrabit']: 0.000001,
    ['pbit', 'petabit']: 0.000000001,
    ['b', 'byte']: 125000,
    ['kb', 'kilobyte']: 125,
    ['mb', 'megabyte']: 0.125,
    ['gb', 'gigabyte']: 0.000125,
    ['tb', 'terrabyte']: 0.000000125,
    ['pb', 'petabyte']: 0.000000000125,
  });
  // currency
}

class Unit {
  final String defaultValue;
  Map<List<String>, double> _convertValues;

  /// if the values can't be converted the default way
  /// two Functions needs to be provided
  /// 1. convert to default value
  /// 2. convert from default value
  Map<List<String>, List<double Function(double)>> _convertCallbacks;

  Unit({
    @required this.defaultValue,
    Map<List<String>, List<double Function(double)>> convertCallbacks,
    Map<List<String>, double> convertValues,
  }) {
    assert((convertCallbacks == null || convertValues == null) &&
        (convertCallbacks != null || convertValues != null));
    if (convertCallbacks == null) {
      _convertValues = convertValues;
      _convertValues.forEach((key, value) {
        if (key.length < 2) {
          key.add(key[0]);
        }
      });
    } else {
      _convertCallbacks = convertCallbacks;
      _convertCallbacks.forEach((key, value) {
        if (key.length < 2) {
          key.add(key[0]);
        }
      });
    }
    Units._add(this);
  }

  double convertValue(String short) {
    assert(_convertValues != null);
    return _convertValues[
        _convertValues.keys.firstWhere((key) => key.first == short)];
  }

  List<double Function(double)> convertCallback(String short) {
    assert(_convertCallbacks != null);
    return _convertCallbacks[
        _convertCallbacks.keys.firstWhere((key) => key.first == short)];
  }

  List<List<String>> get keys =>
      (_convertValues == null ? _convertCallbacks.keys : _convertValues.keys)
          .toList();

  double convertTo(String startUnit, String endUnit, double value) {
    return convertFromDefault(endUnit, convertToDefault(startUnit, value));
  }

  double convertToDefault(String startUnit, double value) {
    if (_convertCallbacks == null) {
      print(
          'convertToDefault: value: $value | convertValue: ${convertValue(startUnit)} | short: $startUnit');
      return value / convertValue(startUnit);
    } else {
      return convertCallback(startUnit)[0](value);
    }
  }

  double convertFromDefault(String endUnit, double value) {
    if (_convertCallbacks == null) {
      return value * convertValue(endUnit);
    } else {
      return convertCallback(endUnit)[1](value);
    }
  }

  bool hasUnit({String unit}) => _convertValues.keys.contains(unit);

  List<DropdownMenuItem> getDropdownList() {
    List<DropdownMenuItem> items = [];
    items = keys.map((List<String> def) {
      return DropdownMenuItem<String>(value: def[0], child: Text(def[0]));
    }).toList();
    return items;
  }
}
