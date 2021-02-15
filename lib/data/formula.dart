import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:all_the_formulars/data/unit.dart';
import 'package:all_the_formulars/utils.dart';

abstract class FormulaBase {
  // both vars are keys to Localized String
  final String name;
  final String description;
  const FormulaBase({
    this.name,
    this.description,
  });
}

class Formula extends FormulaBase {
  final String defaultResult;

  /// key: variable
  /// val[0]: formula changed to var
  /// val[1]: meaning of var
  /// val[2]: deafult unit
  final Map<String, List<String>> varData;

  const Formula({
    @required String name,
    @required String description,
    @required this.defaultResult,
    @required this.varData,
  }) : super(name: name, description: description);
  /* {
    assert(formula.contains(defaultResult));
    changedFormulas.keys.forEach((key) {
      assert(formula.contains(key));
    });
    Formulas._add(this);
  }*/

  String get formula => varData[defaultResult][0];

  String meaning(String variable) => varData[variable][1];

  String defaultUnit(String variable) => varData[variable][2];

  Unit unitOf(String variable) => Units.getFromShort(defaultUnit(variable));

  String changeTo({@required String result}) => varData[result][0];

  double calculate(String resultVar, Map<String, double> values) {
    String _formula = changeTo(result: resultVar).split('=')[1].trim();

    // convert 4a to 4 * a
    List<String> parts = _formula.split(' ');
    int i = 0;
    parts.forEach((part) {
      // check if part contains a number and a letter but not '^'
      // it assumes the number is always in the front
      if (part.contains(RegExp(r'[0-9]')) &&
          part.contains(RegExp(r'[a-z]', caseSensitive: false)) &&
          !part.contains('^')) {
        int index = part.lastIndexOf(RegExp(r'[0-9]'));
        String num = part.substring(0, index + 1);
        String variable = part.substring(index + 1);
        parts[i] = '$num * $variable';
      }
      i++;
    });
    _formula = parts.join(' ');

    print('formula $_formula');

    // put values
    values.forEach((key, value) {
      _formula = _formula.replaceAll(key, value.toString());
    });

    return _FormulaTools(_formula).calculate();
  }

  static String toCaTeX(String rawFormula) {
    List<String> values = rawFormula.split(' ');
    String catex = '';
    values.forEach((variable) {
      bool hasPower = false;
      List<String> parts;
      if (variable.contains('^')) {
        hasPower = true;
        parts = variable.split('^');
        variable = parts[0];
      }
      if (_CaTeXvalues.keys.contains(variable)) {
        if (hasPower) {
          catex += _CaTeXvalues[variable] + '^' + parts[1] + ' ';
        } else
          catex += _CaTeXvalues[variable] + ' ';
      } else {
        if (hasPower)
          catex += variable + '^' + parts[1] + ' ';
        else
          catex += variable + ' ';
      }
    });
    return catex;
  }

  String toCaTeX2({List<String> value}) {
    value ??= formula.split(' ');
    String catex = '';
    value.forEach((variable) {
      bool hasPower = false;
      List<String> parts;
      if (variable.contains('^')) {
        hasPower = true;
        parts = variable.split('^');
        variable = parts[0];
      }
      if (_CaTeXvalues.keys.contains(variable)) {
        if (hasPower) {
          catex += _CaTeXvalues[variable] + '^' + parts[1] + ' ';
        } else
          catex += _CaTeXvalues[variable] + ' ';
      } else {
        if (hasPower)
          catex += variable + '^' + parts[1] + ' ';
        else
          catex += variable + ' ';
      }
    });
    return catex;
  }

  static const Map<String, String> _CaTeXvalues = {
    '√{': r'\sqrt {',
    ':{': r'\frac {',
    '}/{': '}{',
    '/{': '{',
    '}/': '}',
    '²': '^2',
    '³': '^3',
    '*': r'\cdot',
    '×': r'\cdot',
    'sin[': 'sin(',
    'cos[': 'cos(',
    'tan[': 'tan(',
    'asin[': 'asin(',
    'acos[': 'acos(',
    'atan[': 'atan(',
    ']': ')',
    'alpha': r'\alpha',
    'beta': r'\beta',
    'gamma': r'\gamma',
    'delta': r'\delta',
    'epsilon': r'\epsilon',
    'zeta': r'\zeta',
    'eta': r'\eta',
    'theta': r'\theta',
    'iota': r'\upsilon',
    'kappa': r'\kappa',
    'lambda': r'\lambda',
    'mu': r'\mu',
    'nu': r'\nu',
    'ksi': r'\ksi',
    'omicron': r'\omicron',
    'pi': r'\pi',
    'rho': r'\rho',
    'sigma': r'\sigma',
    'tau': r'\tau',
    'ypsilanti': r'\ypsilon',
    'phi': r'\phi',
    'chi': r'\chi',
    'omega': r'\omega',
  };
}

class FormulaCategory extends FormulaBase {
  final List<FormulaBase> content;

  const FormulaCategory(
      {@required String name,
      @required String description,
      @required this.content})
      : super(name: name, description: description);

  List<Formula> getFormulas() {
    return content.where((e) => e is Formula).toList();
  }

  List<FormulaCategory> getCategorys() {
    return content.where((e) => e is FormulaCategory).toList();
  }
}

class FormulaPath {
  List<String> path;
  String formula;
  String joiner;
  FormulaPath({
    this.path,
    this.joiner = ' > ',
  }) {
    formula ??= '';
    path ??= [''];
  }

  String get fullPath => path.join(joiner) + joiner + formula;

  void append(String subPath) {
    if (path == ['']) path = [];
    path.add(subPath);
  }

  void remove(String subPath) {
    path.removeRange(path.indexOf(subPath), path.length);
  }
}

class _FormulaTools {
  /// formula with already set values and without '='
  String formula;
  List<String> parts;

  _FormulaTools(
    this.formula,
  ) {
    parts = formula.split(' ');
  }

  /// finds opening or closing index of brackets based on index in [parts]
  int findPartnerIndex(int startIndex,
      {bool findOpening = false, bool findMiddlepart = false}) {
    String type;
    if (parts[startIndex] == '(' || parts[startIndex] == ')') {
      type = '()';
    } else if (parts[startIndex].contains('{') || parts[startIndex] == '}') {
      type = '{}';
    } else if (parts[startIndex].contains('[') || parts[startIndex] == ']') {
      type = '[]';
    }

    if (!findOpening && !findMiddlepart) {
      int c = 1;
      for (int i = startIndex + 1; i < parts.length; i++) {
        if (parts[i].contains(type[1])) c--;
        if (parts[i].contains(type[0])) c++;
        if (c == 0) {
          return i;
        }
      }
    }
    if (findOpening && !findMiddlepart) {
      int c = 1;
      for (int i = startIndex - 1; i > 0; i++) {
        if (parts[i].contains(type[1])) c++;
        if (parts[i].contains(type[0])) c--;
        if (c == 0) {
          return i;
        }
      }
    }
    if (!findOpening && findMiddlepart) {
      if (parts[startIndex].contains('}')) {
        for (int i = startIndex - 1; i > 0; i++) {
          if (parts[i] == '}/{') return i;
        }
      } else if (parts[startIndex].contains('{')) {
        for (int i = startIndex + 1; i < parts.length; i++) {
          if (parts[i] == '}/{') return i;
        }
      }
    }
    throw Exception('Did not find partner Index');
  }

  // values should already be set
  double calculate() {
    // do the whole process for each paranthenses and curly brackets
    solveBrackets();

    // solve superscripts (^2, ^3...) and roots and sin, cos & tan
    solveSuperscript();

    // solve multiplications and divisions
    solvePoints();

    // solve addition and subtraction
    solveLines();

    // should now be solved
    assert(parts.length == 1);
    return toDouble(parts[0]);
  }

  void solveBrackets() {
    if (formula.contains('(') || formula.contains('{')) {
      print('Solving contents of brackets');
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].contains('(') || parts[i].contains('{')) {
          String subFormula;
          int closing;
          if (parts[i].contains(':')) {
            closing = findPartnerIndex(i, findMiddlepart: true);
          } else {
            closing = findPartnerIndex(i);
          }
          subFormula = parts.sublist(i + 1, closing).join(' ');
          double endVal = _FormulaTools(subFormula).calculate();
          parts.replaceRange(i + 1, closing, [endVal.toString()]);
        }
      }
    }
  }

  void solveSuperscript() {
    while (parts.where((e) => e.contains('^') && !e.contains('√')).length > 0) {
      print('Solving superscript');
      int i = 0;
      parts.forEach((part) {
        if (part.contains('^')) {
          print('solving $part');
          final int index = part.indexOf('^');
          double val = toDouble(part.substring(0, index));
          double exp = toDouble(part.substring(index + 1));
          parts[i] = pow(val, exp).toString();
          print('solved ${parts[i]}');
        }
        i++;
      });
    }

    while (parts.where((e) => e.contains('√{')).length > 0) {
      print('Solving root');
      int index = parts.indexOf(parts.firstWhere((e) => e.contains('√{')));
      // closing index should be index + 2
      assert(findPartnerIndex(index) == index + 2);
      double value = toDouble(parts[index + 1]);
      double exp =
          toDouble(parts[index].substring(1, parts[index].indexOf('√') + 1));
      value = pow(value, exp);
      parts.replaceRange(index, index + 3, [value.toString()]);
    }
  }

  /// solves multiplication and devision
  void solvePoints() {
    while (parts.where((e) => e.contains(':')).length > 0) {
      print('Solving devisions');
      int index = parts.indexOf(':{');
      // closing index should be index + 4
      assert(findPartnerIndex(index) == index + 4);
      double topVal = toDouble(parts[index + 1]);
      double bottomVal = toDouble(parts[index + 3]);
      double endVal = topVal / bottomVal;
      parts.replaceRange(index, index + 5, [endVal.toString()]);
    }

    while (parts.where((e) => e.contains('*')).length > 0) {
      print('Solving multiplications');
      int index = parts.indexOf('*');
      double val1 = toDouble(parts[index - 1]);
      double val2 = toDouble(parts[index + 1]);
      double endVal = val1 * val2;
      parts.replaceRange(index - 1, index + 2, [endVal.toString()]);
    }
  }

  void solveLines() {
    while (parts.where((e) => e.contains('+') || e.contains('-')).length > 0) {
      print('Solving Addition or Subtraction');
      int index = Utils.min2(parts.indexOf('+'), parts.indexOf('-'));
      double val1 = toDouble(parts[index - 1]);
      double val2 = toDouble(parts[index + 1]);
      double endVal;
      if (parts[index] == '+') {
        endVal = val1 + val2;
      } else if (parts[index] == '-') {
        endVal = val1 - val2;
      }
      parts.replaceRange(index - 1, index + 2, [endVal.toString()]);
    }
  }

  double toDouble(String val) {
    print('Try parsing $val to double');
    return double.parse(val);
  }
}
