import 'package:all_the_formulars/core/utils.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Units {
  static Length lengthAll = Length('m', {'km' : 0.001, 'm': 1, 'cm' : 100, 'mm' : 1000, 'mile' : 0.000621371, 'foot' : 3.28084, 'inch' : 39.3701});
  static Length lengthMetric = Length('m', {'km' : 0.001, 'm': 1, 'cm' : 100, 'mm' : 1000});
  static Length lengthAmeric = Length('inch', {'mile' : 0.0000157828, 'foot' : 0.0833333, 'inch' : 1});

  static Length area = Length('m²', {'km²' : 0.000001, 'm²': 1, 'cm²' : 10000, 'mm²' : 1000000, 'mile²' : 0.000621371, 'foot²' : 3.28084, 'inch²' : 39.3701});
  static Length volume = Length('m³', {'km³' : 0.000000001, 'm³': 1, 'cm³' : 1000000, 'mm³' : 1000000000, 'mile³' : 0.000621371, 'foot³' : 3.28084, 'inch³' : 39.3701});
  
  static Speed speed = Speed('m/s', {'km/h' : 3.6, 'm/s' : 1, 'mile/h' : 2.23694, 'foot/s' : 3.28084});
  static Speed acceleration = Speed('m/s²', {'Gal' : 0.01, 'm/s²' : 1});
  static Speed rotationalSpeed = Speed(L.string('rpm'), {L.string('rpm') : 1, L.string('rps') : 0.0166666667});

  static Mass mass = Mass('kg', {'t' : 0.001, 'kg' : 1, 'g' : 1000, 'mg' : 1000000, 'lt' : 0.000984207, 'st' : 0.00110231, 'lb' : 2.20462, 'oz' : 35.274});

  static Unit2 angle = Unit2('°', {'°' : 1});

  static Unit2 time = Unit2('min', {'ms' : 60000,'s' : 60, 'min' : 1, 'h' : -60, 'd' : -1440});

  static Unit2 force = Unit2('N', {'N' : 1, 'kN' : 0.001});

  static Unit2 data = Unit2('mbit', {'bit' : 1000000, 'kbit' : 1000, 'mbit' : 1, 'gbit' : 0.001, 'tbit' : 0.000001, 'pbit' : 0.000000001, 'b' : 125000, 'Kb' : 125, 'Mb' : 0.125, 'Gb' : 0.000125, 'Tb' : 0.000000125, 'Pb' : 0.000000000125});

  static Unit getUnitFromString(String unitShort) {
    Unit result;
    units.forEach((unit) {
      unit.unitsWithConversion.forEach((key, value) {
        if(key == unitShort) {
          result = unit;
        }
      });
    });
    return result == null ?
    throw Exception('Unit $unitShort could not be found') : result;
  }

  static List<Unit> units = [
    lengthAll,
    area,
    volume,
    angle,
    speed,
    acceleration,
    rotationalSpeed,
    mass,
    time,
    force
  ];
}

abstract class Unit {

  String main;
  Map<String, double> unitsWithConversion;

  Unit(this.main, this.unitsWithConversion);
  
  double getValueOf(String unit, double value, {String resultUnit});

  List<DropdownMenuItem> getDropdownList();

  //double getValueOf(String unit, double value);
}

double getFactor(double value) => value > 0 ? value : 1 / (-1 * value);

class Unit2 extends Unit {
  String main;
  Map<String, double> unitsWithConversion;

  Unit2(this.main, this.unitsWithConversion) : super(main, unitsWithConversion) {
    selectValue = main;
  }

  var selectValue;

  /// returns the converted length from [unit] to [resultUnit] with [value]
  @override
  double getValueOf(String unit, double value, {String resultUnit}) {
    if (!unitsWithConversion.keys.contains(unit)) {
      throw FormatException('This unit ($unit) is not in the object.');
    }
    resultUnit ??= main;
    if (!unitsWithConversion.keys.contains(resultUnit)) {
      throw FormatException(
          'This resultUnit ($resultUnit) is not in the object.');
    }

    double mainValue = value / getFactor(unitsWithConversion[unit]);

    return mainValue * getFactor(unitsWithConversion[resultUnit]);
  }

  @override
  List<DropdownMenuItem> getDropdownList() {
    List<DropdownMenuItem> items = [];
    items = unitsWithConversion.keys.map((String unit) {
      return DropdownMenuItem<String>(
          value: unit, child: Text(unit));
    }).toList();
    return items;
  }
}

class Length extends Unit {

  String main;
  Map<String, double> unitsWithConversion;

  Length(this.main, this.unitsWithConversion) : super(main, unitsWithConversion) {
    selectValue = main;
  }

  var selectValue;

  /// returns the converted length from [unit] to [resultUnit] with [value]
  @override
  double getValueOf(String unit, double value, {String resultUnit}) {
    if (!unitsWithConversion.keys.contains(unit)) {
      throw FormatException('This unit ($unit) is not in the object.');
    }
    resultUnit ??= main;
    if (!unitsWithConversion.keys.contains(resultUnit)) {
      throw FormatException(
          'This resultUnit ($resultUnit) is not in the object.');
    }

    double mainValue = value / getFactor(unitsWithConversion[unit]);

    return mainValue * getFactor(unitsWithConversion[resultUnit]);
  }

  @override
  List<DropdownMenuItem> getDropdownList() {
    List<DropdownMenuItem> items = [];
    items = unitsWithConversion.keys.map((String unit) {
      return DropdownMenuItem<String>(
          value: unit, child: Text(unit));
    }).toList();
    return items;
  }
}

class Speed extends Unit {

  String main;
  Map<String, double> unitsWithConversion;

  Speed(this.main, this.unitsWithConversion)
      : super(main, unitsWithConversion);

  /// returns the converted length from [unit] to [resultUnit] with [value]
  @override
  double getValueOf(String unit, double value, {String resultUnit}) {
    if (!unitsWithConversion.keys.contains(unit)) {
      throw FormatException('This unit ($unit) is not in the object.');
    }
    resultUnit ??= main;
    if (!unitsWithConversion.keys.contains(resultUnit)) {
      throw FormatException(
          'This resultUnit ($resultUnit) is not in the object.');
    }

    double mainValue = value / getFactor(unitsWithConversion[unit]);

    return mainValue * getFactor(unitsWithConversion[resultUnit]);
  }

  @override
  List<DropdownMenuItem> getDropdownList() {
    List<DropdownMenuItem> items = [];
    items = unitsWithConversion.keys.map((String unit) {
      return DropdownMenuItem<String>(
          value: unit, child: Text(unit));
    }).toList();
    return items;
  }
}

class Mass extends Unit {

  String main;
  Map<String, double> unitsWithConversion;

  Mass(this.main, this.unitsWithConversion)
      : super(main, unitsWithConversion);

  /// returns the converted length from [unit] to [resultUnit] with [value]
  @override
  double getValueOf(String unit, double value, {String resultUnit}) {
    if (!unitsWithConversion.keys.contains(unit)) {
      throw FormatException('This unit ($unit) is not in the object.');
    }
    resultUnit ??= main;
    if (!unitsWithConversion.keys.contains(resultUnit)) {
      throw FormatException(
          'This resultUnit ($resultUnit) is not in the object.');
    }

    double mainValue = value / unitsWithConversion[unit];

    return mainValue * unitsWithConversion[resultUnit];
  }

  @override
  List<DropdownMenuItem> getDropdownList() {
    List<DropdownMenuItem> items = [];
    items = unitsWithConversion.keys.map((String unit) {
      return DropdownMenuItem<String>(
          value: unit, child: Text(unit));
    }).toList();
    return items;
  }
}