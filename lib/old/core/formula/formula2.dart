import 'dart:math';

import 'package:all_the_formulars/old/core/utils.dart';

import 'calculate.dart';

class Formula2 {
  String originalResult;
  String raw;
  String parsedRaw;
  Map<String, String> changedFormulas = {};

  Formula2(this.raw, {this.changedFormulas}) {
    _sides = raw.split('=');
    //sides[0] += '=';
    parseRaw(determineSides: true);

    _sidedValues.forEach((side) {
      side.forEach((value) {
        bool isDupe = false;
        if (!isOperator(value) &&
            value != '=' &&
            !variables.contains(value) &&
            !Utils.isNumeric(value) &&
            !isConstant(value)) {
          if (value.contains('^')) {
            String WOpow =
                value.replaceRange(value.indexOf('^'), value.length, '');
            value = WOpow;
            if (variables.contains(WOpow)) {
              isDupe = true;
            }
          }
          if (!isDupe) {
            if (value.length > 1 &&
                !value.contains('_') &&
                !isGreekLetter(value)) {
              variables.add(value[value.length - 1]);
            } else
              variables.add(value);
          }
        }
      });
    });
    lastAction = '';
    originalResult = _values[0];
  }

  String lastAction = '';
  String result;

  List<String> _values = [];
  List<String> _parsedSides;
  List<String> _sides;
  List<List<String>> _sidedValues = List()..length = 0;
  List<List<String>> _parsingValues = List()..length = 0;
  List<String> variables = [];

  List<String> get values => _values;
  List<String> get parsedSides => _parsedSides;
  List<String> get sides => _sides;
  List<List<String>> get sidedValues => _sidedValues;
  set sidedValues(List<List<String>> list) => _sidedValues = list;

  /// Fills sidedValues and parses it
  void parseRaw(
      {List<String> sides,
      bool determineSides = false,
      bool switchTrigonometric = true}) {
    _sidedValues.clear();
    sides ??= _sides;

    _parsingValues = List()..length = 0;
    String lastChar = '§§§';
    int lastIndex = -1;
    String current = '§§§';

    for (int i = 0; i < sides.length; i++) {
      _parsingValues.add([]);
      lastIndex = -1;
      current = '§§§';
      lastChar = '§§§';
      inner:
      for (int j = 0; j < sides[i].length; j++) {
        current = sides[i][j];

        // android times symbol support
        if (current == '×') current = '*';

        switch (current) {
          case ' ':
            continue inner;
          default:
            {
              if (isTypeOf(current, lastChar)) {
                // now better than ever
                if (((isFriendlyOperator(current) &&
                            isFriendlyOperator(lastChar)) ||
                        !(isOperator(current) && isOperator(lastChar))) &&
                    lastChar != current) {
                  current = lastChar + current;
                  _parsingValues[i][lastIndex] = current;
                  lastIndex--;
                } else {
                  _parsingValues[i].add(current);
                }
              } else {
                _parsingValues[i].add(current);
              }
              lastChar = current;
              lastIndex++;
            }
        }
      }
      if (isCalcOperator(_parsingValues[i].last)) {
        _parsingValues[i].removeLast();
      }
      if (isCalcOperator(_parsingValues[i].first)) {
        _parsingValues[i].removeAt(0);
      }
    }

    applyToFormula(
        determineSides: determineSides,
        switchTrigonometric: switchTrigonometric);
    //print('parsing: $_parsingValues');
    //applyToFormula();
  }

  void checkBrackets() {
    if (sidedValues[0].first.contains('[') &&
        sidedValues[0][sidedValues[0].length - 2] == ']') {
      switch (sidedValues[0].first) {
        case 'sin[':
          sidedValues[1].insert(0, 'asin[');
          sidedValues[1].add(']');
          break;
        case 'cos[':
          sidedValues[1].insert(0, 'acos[');
          sidedValues[1].add(']');
          break;
        case 'tan[':
          sidedValues[1].insert(0, 'atan[');
          sidedValues[1].add(']');
          break;
      }
      sidedValues[0].removeAt(0);
      sidedValues[0].removeAt(sidedValues[0].length - 2);
    }
  }

  void applyToFormula(
      {bool determineSides = false, bool switchTrigonometric = true}) {
    if (determineSides) determineArrangement();
    _sidedValues = _parsingValues;
    if (_sidedValues[0].contains('=')) _sidedValues[0].remove('=');
    _sidedValues[0].add('=');

    if (switchTrigonometric) switchSideOfBrackets(fromSide: 0);

    _values = [];
    _values.addAll(_sidedValues[0]);
    _values.addAll(_sidedValues[1]);
    parsedRaw = _sidedValues[0].join(' ') + ' ' + _sidedValues[1].join(' ');
    _parsedSides = parsedRaw.split('=');
    result = _values[0];
  }

  void determineArrangement() {
    print('Parsingvalues: $_parsingValues');
    if (_parsingValues[0].length > _parsingValues[1].length) {
      var temp = _parsingValues[0];
      _parsingValues[0].remove('=');
      _parsingValues[1].add('=');
      _parsingValues[0] = _parsingValues[1];
      _parsingValues[1] = temp;
    }
  }

  /// changes the formula to the given result
  void changeTo(String result) {
    if (result != originalResult) {
      if (!_values.contains(result) || isOperator(result)) {
        bool foundExpResult = false;
        int i = 0;
        while (i < 10 && !foundExpResult) {
          if (_values.contains('$result^$i')) {
            foundExpResult = true;
            result += '^$i';
          }
          i++;
        }
        if (!foundExpResult)
          throw FormatException(
              'Formula can not be changed to an operator or an not existent variable.');
      }
    }

    if (_sidedValues[0].contains(result) && _sidedValues[0].length < 3) return;

    logcat('Begin changing to $result');
    lastAction = '';
    //change formula back to original
    parseRaw(determineSides: true, switchTrigonometric: false);

    if (changedFormulas.length > 0) {
      print('Using pre defined changed Formula');
      _sidedValues = Formula2(changedFormulas[result])._sidedValues;
      applyToFormula();
    } else {
      //TODO: - Priority: 8 - support multiple of the same var in a formula f.e. V = :{h}/{3} * (A_1 + A_2 + √{A_1 * A_2})

      if (result != originalResult) {
        logcat('  result is not original result');

        switchSideOfBrackets();

        if (!isInBrace(result) && _sidedValues[1].contains('(')) {
          switchSideOf(getRangeAsString(_sidedValues[1].indexOf('('),
              findClosingIndex(_sidedValues[1].indexOf('('), type: '()')));
        }

        if (isInRoot(result)) {
          if (_sidedValues[1].first == '√{' && _sidedValues[1].last == '}') {
            square();
          } else {
            // put everything else on the other side
            bool hasPreVars = _sidedValues[1].first != '√{';
            bool hasPostVars = _sidedValues[1].last != '}';
            int index = _sidedValues[1].indexOf('√{');

            if (hasPostVars) {
              print('sidedValues[1].length: ${_sidedValues[1].length}');
              clearLine(result,
                  start: findClosingIndex(_sidedValues[1].indexOf('√{')) + 1,
                  end: _sidedValues[1].length - 1);
            }
            if (hasPreVars)
              clearLine(result,
                  start: 0, end: _sidedValues[1].indexOf('√{') - 1);

            square();
          }
        } else if (_sidedValues[1].contains('√{')) {
          print('sidedValues: $_sidedValues');
          switchSideOf(getRangeAsString(_sidedValues[1].indexOf('√{'),
              findClosingIndex(_sidedValues[1].indexOf('√{'))));
        }

        while (_sidedValues[1].contains(':{')) {
          int firstIndex = _sidedValues[1].indexOf(':{');
          int lastIndex = _sidedValues[1].lastIndexOf(':{');
          logcat('firstIndex: $firstIndex');
          logcat('lastIndex: $lastIndex');
          if (firstIndex != lastIndex) {
            logcat('Multiple Divider found');
            if (isInDivider(result, index: firstIndex)) {
              logcat('Result is in first Divider');
              //clear lastIndex
              String top = _sidedValues[1]
                  .getRange(
                      _sidedValues[1].lastIndexOf(':{') + 1,
                      findClosingIndex(_sidedValues[1].lastIndexOf(':{'),
                          findMidOperator: true))
                  .join(' ');
              multiply(List<String>.from(_sidedValues[1].getRange(
                  _sidedValues[1].lastIndexOf('}/{') + 1,
                  findClosingIndex(_sidedValues[1].lastIndexOf('}/{')))));
              switchSideOf(top);
            } else {
              logcat('Result is in last Divider');
              //clear first index
              String top = _sidedValues[1]
                  .getRange(
                      _sidedValues[1].indexOf(':{') + 1,
                      findClosingIndex(_sidedValues[1].indexOf(':{'),
                          findMidOperator: true))
                  .join(' ');
              multiply(List<String>.from(_sidedValues[1].getRange(
                  _sidedValues[1].indexOf('}/{') + 1,
                  findClosingIndex(_sidedValues[1].indexOf('}/{')))));
              switchSideOf(top);
            }
          } else if (isInDivider(result)) {
            if (_sidedValues[1].first == ':{' && _sidedValues[1].last == '}') {
              if (isNumerator(result)) {
                logcat('Result is numerator');
                multiply(List<String>.from(_sidedValues[1].getRange(
                    _sidedValues[1].indexOf('}/{') + 1,
                    findClosingIndex(_sidedValues[1].indexOf('}/{')))));
              } else {
                logcat('Result is not numerator');
                divide(
                    List<String>.from(_sidedValues[1].getRange(
                        _sidedValues[1].indexOf(':{') + 1,
                        _sidedValues[1].indexOf('}/{'))),
                    areNumerators: true);
              }
            } else {
              logcat('Clean up before and after Divider');
              // put everything else on the other side
              bool hasPreVars = _sidedValues[1].first != ':{';
              bool hasPostVars = _sidedValues[1].last != '}';
              int index = _sidedValues[1].indexOf(':{');

              if (hasPostVars) {
                print('sidedValues[1].length: ${_sidedValues[1].length}');
                clearLine(result,
                    start: findClosingIndex(_sidedValues[1].indexOf(':{')) + 1,
                    end: _sidedValues[1].length - 1);
                logcat(' has post vars end');
              }
              if (hasPreVars) {
                logcat(' has pre vars');
                clearLine(result,
                    start: 0, end: _sidedValues[1].indexOf(':{') - 1);
                logcat(' has pre vars end');
              }

              logcat('$result isNumerator = ${isNumerator(result)}');

              if (isNumerator(result)) {
                logcat('Result is numerator');
                multiply(List<String>.from(_sidedValues[1].getRange(
                    _sidedValues[1].indexOf('}/{') + 1,
                    findClosingIndex(_sidedValues[1].indexOf('}/{')))));
              } else {
                logcat('Result is not numerator');
                divide(
                    List<String>.from(_sidedValues[1].getRange(
                        _sidedValues[1].indexOf(':{') + 1,
                        _sidedValues[1].indexOf('}/{'))),
                    areNumerators: true);
              }
            }
          } else {
            logcat('Switching whole Divider');
            String divider = _sidedValues[1]
                .getRange(_sidedValues[1].indexOf(':{'),
                    findClosingIndex(_sidedValues[1].indexOf(':{')) + 1)
                .join(' ');

            if (_sidedValues[0].contains(':{') ||
                _getNextOperatorOfDivider(divider) == '*') {
              String top = _sidedValues[1]
                  .getRange(
                      _sidedValues[1].indexOf(':{') + 1,
                      findClosingIndex(_sidedValues[1].indexOf(':{'),
                          findMidOperator: true))
                  .join(' ');
              multiply(List<String>.from(_sidedValues[1].getRange(
                  _sidedValues[1].indexOf('}/{') + 1,
                  findClosingIndex(_sidedValues[1].indexOf('}/{')))));
              switchSideOf(top);
            } else {
              switchSideOf(divider);
            }
          }
        }

        logcat('  clearing rest');
        List<String> sidedValuesClone = List.from(_sidedValues[1]);
        sidedValuesClone.forEach((value) {
          logcat('  still remaining: $_sidedValues');
          logcat('  current value: $value');
          if (!isOperator(value) && value != result && !isInBrace(value)) {
            switchSideOf(value);
          }
        });

        if (isInBrace(result)) {
          logcat('  clearing Braces');
          _sidedValues[1].remove('(');
          _sidedValues[1].remove(')');
          logcat('  removed () from sidedValues: ${sidedValues}');
          applyToFormula();
          sidedValuesClone = List.from(_sidedValues[1]);
          sidedValuesClone.forEach((value) {
            if (!isOperator(value) && value != result) {
              switchSideOf(value);
            }
          });
        }
        applyToFormula(determineSides: true);

        if (_values.first.contains('^')) {
          int index = _values.first.indexOf('^');
          int pow = int.parse(_values.first.substring(index + 1));
          root(power: pow, rootResult: true);
        }
      } else {
        applyToFormula(determineSides: true);
      }
    }
    //determineArangement();
    logcat('--Final result: $_sidedValues');
  }

  bool containsMultiple() {
    List<String> vars = [];
    bool result = false;
    logcat('Check for multiple in: $values');
    _values.forEach((value) {
      if (value.contains('^')) {
        value = value.substring(0, value.indexOf('^'));
      }
      if (!isOperator(value) && !isConstant(value) && !Utils.isNumeric(value)) {
        logcat('Value is var: $value');
        if (vars.contains(value)) {
          logcat('Found multiple');
          result = true;
        }
        vars.add(value);
      }
    });
    return result;
  }

  String _getNextOperatorOfDivider(String divider) {
    String nextOperator;
    int index = _values.indexOf(divider.split(' ')[0]);
    if (index == 0 || _values[index - 1] == '=') {
      index = _values.indexOf(divider.split(' ').last);
      nextOperator = _values[index + 1];
    } else {
      nextOperator = _values[index - 1];
    }
    return nextOperator;
  }

  String getRangeAsString(int start, int end, {int side = 1}) {
    print('getRange: start: $start | end: $end');
    return List<String>.from(_sidedValues[side].getRange(start, end + 1))
        .join(' ');
  }

  bool hasNext(String value, {int side = 1, bool operator = false}) {
    int index = _sidedValues[side].indexOf(value);
    if (_sidedValues[side].last == value) return false;

    while (index + 1 < _sidedValues[side].length) {
      if (isOperator(_sidedValues[side][index + 1])) {
        index++;
      } else {
        return true;
      }
    }
    return false;
  }

  String nextOperatorOf(String value, {int side = 1}) {
    if (_sidedValues[side].last == value) return null;
    String next = _sidedValues[side][_sidedValues[side].indexOf(value) + 1];
    if (isCalcOperator(next)) return next;
    return null;
  }

  /// start and end are from _sidedValues[1]
  /// should not contain roots, braces or divides just +, -, * and variables
  void clearLine(String result, {int start, int end, int side = 1}) {
    print('--cleaning line from $start to $end');
    assert((start != null && end != null));

    List<int> cdotList = [];
    List<String> multiplierLines = [];
    int adjustIndex = 0;
    for (int i = start; i < end; i++) {
      if (_sidedValues[side][i] == '*') {
        cdotList.add(i);
      }
    }

    print('  cdotList: $cdotList');
    if (cdotList.length > 0) {
      int lastIndex = 0;
      cdotList.forEach((index) {
        if (lastIndex != 0) {
          if (index - lastIndex == 2) {
            if (!(isOperator(_sidedValues[side][index - 2]) &&
                    isOperator(_sidedValues[side][index - 1])) &&
                (_sidedValues[side][index - 2] != result &&
                    _sidedValues[side][index - 1] != result)) {
              multiplierLines.last += ' ' +
                  _sidedValues[side][index - 2] +
                  ' ' +
                  _sidedValues[side][index - 1];
            }
          } else {
            if (!isOperator(_sidedValues[side][index - 1]) &&
                _sidedValues[side][index - 1] != result) {
              multiplierLines.add(_sidedValues[side][index - 1]);
            }
            /* else if(!isOperator(_sidedValues[side][index+1])) {
              multiplierLines.add(_sidedValues[side][index+1]);
            }
            */
          }
        } else {
          if (!isOperator(_sidedValues[side][index - 1]) &&
              _sidedValues[side][index - 1] != result) {
            multiplierLines.add(_sidedValues[side][index - 1]);
          }
          /* else if(!isOperator(_sidedValues[side][index+1])) {
            multiplierLines.add(_sidedValues[side][index+1]);
          }*/
        }
        lastIndex = index;
      });

      print('  multiplierLines: $multiplierLines');
      multiplierLines.forEach((variable) {
        adjustIndex += variable.split(' ').length;
        divide([variable]);
      });
    }

    print('  adjustedIndex $adjustIndex');
    print('  sidedValues: ${_sidedValues[side]}');
    print('  start: $start');
    print('  end: $end');
    if (isOperator(_sidedValues[side][end - adjustIndex])) {
      logcat('  start i is Operator');
      end -= 1;
    }
    for (int i = end - adjustIndex; i >= start; i -= 2) {
      logcat('  i: $i');
      if (!isOperator(_sidedValues[side][i]))
        switchSideOf(_sidedValues[side][i]);
    }
  }

  void switchSideOf(String value) {
    logcat(' ');
    logcat('Switching side of $value');
    logcat('_values before switching: $_values');
    int valueIndex = _values.indexOf(value.split(' ')[0]);
    int start = value.split(' ').length > 1 ? valueIndex : 0;

    String nextOperator;
    bool isNext = false;

    if (valueIndex == 0 || _values[valueIndex - 1] == '=') {
      valueIndex = start > 0
          ? value.split(' ').length - 1
          : _values.indexOf(value.split(' ')[0]);
      nextOperator = _values[valueIndex + 1 + start];
      isNext = true;
    } else {
      nextOperator = _values[valueIndex - 1];
    }

    logcat('isNext: $isNext');
    logcat('nextOperator: $nextOperator');
    logcat('valueIndex: $valueIndex');
    logcat('values: $_values');
    logcat('value: ${value.split(' ')}');
    List<String> values = value.contains(' ') ? value.split(' ') : [value];

    switch (nextOperator) {
      case '+':
        subtract(values);
        break;
      case '-':
        add(values, opIsNext: isNext);
        break;
      case '*':
        divide(values);
        break;
      case ':{':
        divide(values, areNumerators: true);
        break;
      case '}/{':
        isNext ? divide(values, areNumerators: true) : multiply(values);
        break;
    }
    lastAction = nextOperator;
  }

  int findClosingIndex(int start,
      {int side = 1,
      String type = '{}',
      bool findMidOperator = false,
      List<String> list}) {
    list ??= _sidedValues[side];
    logcat('findClosing: start: $start of $list');
    int count = 1;
    if (!findMidOperator) {
      int i = start + 1;
      while (true) {
        //logcat('findClosing: list[i]: ${list[i]}');
        if (list[i].contains(type[0]) && list[i] != '}/{') count++;
        if (list[i].contains(type[1]) && list[i] != '}/{') count--;
        //logcat('findClosing: count: $count');
        if (count == 0) return i;
        i++;
      }
    } else {
      int i = start + 1;
      while (true) {
        //logcat('findClosing: list[i]: ${list[i]}');
        if (list[i].contains(type[0])) count++;
        if (list[i].contains(type[1])) count--;
        if (list[i].contains('/')) count = 0;
        if (count == 0) return i;
        i++;
      }
    }
  }

  /// Checks if two given values are of the same type
  bool isTypeOf(String val, String compareTo) {
    if (val == '§§§' || compareTo == '§§§' || val == '=' || compareTo == '=')
      return false;

    if (!isOperator(val) && !isOperator(compareTo)) {
      return true;
    } else if (isOperator(val) && isOperator(compareTo)) {
      return true;
    }

    return false;
  }

  /// given formula:
  /// V = :{a + b * c}/{x² - x} * √{pi * 2d}
  ///   turn 2d into 2 * d
  ///   V = :{a + b * c}/{x² - x} * √{pi * 2 * d}
  ///   given value map
  ///   {a:2 , b:4 , c:7 , x:4.3 , d:16}
  ///   replace variables with values
  ///   V = :{2 + 4 * 7}/{4.3² - 4.3} * √{3.14 * 2 * 16}
  ///
  /// parse [_parseForCalc]
  ///
  /// calculating:
  /// 1. clear squares => 2² -> 4
  ///   V = :{2 + (4 * 7)}/{18,49 - 4.3} * √{(3.14 * 2 * 16)}
  ///
  /// 2. clear before set braces (from inner to outer)=> 2 + (3 * 4) -> 2 + 12
  ///   V = :{2 + 28}/{18,49 - 4.3} * √{100,704}
  ///
  /// 3. calculate remaining inside curly braces
  ///   V = :{30}/{14.19} * √{100,704}
  ///
  /// 4. clear roots and dividers (from inner to outer)
  ///   V = 2,07 * 10,035
  ///
  /// 5. final step: calculate remaining
  ///   V = 20,77
  String calc(Map<String, double> values) {
    /// Change '2a * 2b' into '2*a * 2*b'
    logcat('-Beginn calculating');
    logcat(' values: $values');
    List<String> calcValues = _values.sublist(_values.indexOf('=') + 1);
    logcat(' values before step 1: $calcValues');
    for (int i = 0; i < calcValues.length; i++) {
      if (i < calcValues.length - 1) {
        if (Utils.isNumeric(calcValues[i]) && calcValues[i + 1] == '(') {
          calcValues.insert(i + 1, '*');
        }
      }
      logcat('  calcValues[i]: ${calcValues[i]}');
      String valueCopy = calcValues[i];
      if (calcValues[i].length > 1 &&
          !isOperator(calcValues[i]) &&
          !Utils.isNumeric(calcValues[i])) {
        int numLength = 0;
        for (int j = 0; j < calcValues[i].length; j++) {
          logcat('  calcValues[i][j]: ${calcValues[i][j]}');
          if (Utils.isNumeric(calcValues[i][j])) {
            logcat('  isNumeric');
            numLength++;
          } else
            break;
        } //22xx
        if (numLength > 0) {
          calcValues[i] = valueCopy.substring(numLength, valueCopy.length);
          calcValues.insert(i, '*');
          calcValues.insert(i, valueCopy.substring(0, numLength));
        }
      }
    }

    logcat(' values before step 2: $calcValues');

    /// Replace variables with Numbers
    for (int i = 0; i < calcValues.length; i++) {
      logcat('  value: ${calcValues[i]}');
      if (!isOperator(calcValues[i]) &&
          calcValues[i] != '=' &&
          !Utils.isNumeric(calcValues[i])) {
        logcat('  replacable');
        if (calcValues[i] == 'pi')
          calcValues[i] = pi.toString();
        else {
          String parseValue = calcValues[i];
          if (parseValue.contains('^')) {
            logcat('  hasPow');
            String pow = parseValue.substring(parseValue.indexOf('^'));
            parseValue = parseValue.replaceRange(
                parseValue.indexOf('^'), parseValue.length, '');
            if (values.keys.contains(parseValue)) {
              calcValues[i] = values[parseValue].toString() + pow;
            }
          } else {
            if (values.keys.contains(parseValue)) {
              logcat('  found in values: ${values[calcValues[i]]}');
              calcValues[i] = values[calcValues[i]].toString();
              logcat('  value: ${calcValues[i]}');
            }
          }
        }
      }
    }

    /// Calculate exponents
    for (int i = 0; i < calcValues.length; i++) {
      if (calcValues[i].contains('^')) {
        int exp;
        double num;
        exp = int.parse(calcValues[i].split('^')[1]);
        num = double.parse(calcValues[i].split('^')[0]);
        calcValues[i] = pow(num, exp).toString();
      }
    }

    Calculate calculator = Calculate(calcFormula: this);

    calcValues = calculator.solveBrackets(calcValues);
    calcValues = calculator.solve(calcValues);
    calcValues = calculator.solveMultiplications(calcValues);
    calcValues = calculator.solveCurlyBrace(calcValues);
    calcValues = calculator.dissolveCurlyBrace(calcValues);
    calcValues = calculator.calcBase(calcValues).keys.first;
    if (calcValues.length > 1) {
      logcat('ROUND ONE OVER : $calcValues');
      calcValues = calculator.solveMultiplications(calcValues);
      calcValues = calculator.solveCurlyBrace(calcValues);
      calcValues = calculator.dissolveCurlyBrace(calcValues);
      calcValues = calculator.calcBase(calcValues).keys.first;
    }

    assert(calcValues.length == 1);
    logcat(' Final result: $calcValues');

    return Utils.dp(double.parse(calcValues.first), 6).toString();
  }

  /// parse:
  ///   wrap * in braces but not if they contain any { or }
  ///     4 * 7 -> (4 * 7) would not contain { or }
  ///     4 * :{6}/{2} -> (4 * :{6}/{2}) would contain {} -> the divider needs to be calculated first
  ///   V = :{2 + (4 * 7)}/{4.3² - 4.3} * √{(3.14 * 2 * 16)}
  List<String> parseForCalc(List<String> formula) {
    if (formula.contains('*')) {
      for (int i = 0; i < formula.length; i++) {
        if (formula[i] == '*') {
          if (Utils.isNumeric(formula[i + 1]) &&
              Utils.isNumeric(formula[i - 1])) {
            formula.insert(i - 1, '<');
            i++;
            formula.insert(i + 2, '>');
            i++;
          }
        }
      }
    }
    return formula;
  }

  void divide(List<String> values,
      {String operator = ' ', bool areNumerators = false}) {
    print('Dividing with $values  and areNumerators $areNumerators');
    bool containsAll = true;
    int i = 0;
    _parsedSides.forEach((parsedSide) {
      containsAll = true;
      values.forEach((string) {
        if (!_sidedValues[i].contains(string)) {
          containsAll = false;
        }
      });
      if (containsAll) {
        print('Side $i has all values');
        scanForOperators(
            values: values.length == 1 ? values[0].split(' ') : values,
            i: i,
            start: _sidedValues[i].indexOf(values.first));

        print('sidedValues: $_sidedValues');
        parsedSide = _sidedValues[i].join(' ');
        print('parsedSide: $parsedSide');
      } else {
        if (areNumerators) {
          parsedSide =
              ':{ ' + values.join(' $operator ') + ' }/{ $parsedSide }';
        } else {
          if (lastAction == '*') {
            logcat('lastAction was * ');
            parsedSide = getRangeAsString(
                    0,
                    findClosingIndex(_sidedValues[i].indexOf(':{'), side: i) -
                        1,
                    side: i) +
                ' * ' +
                values.join(operator) +
                getRangeAsString(
                    findClosingIndex(_sidedValues[i].indexOf(':{'), side: i),
                    _sidedValues[i].length - 1,
                    side: i);
            //int replaceIndex = findClosingIndex(_sidedValues[0].indexOf(':{'), side: 0, list: parsedSide.split(' '))-1;
            //parsedSide = parsedSide.replaceRange(replaceIndex, replaceIndex, ' ${values.join(operator)} ');
            logcat(' parsedSide: $parsedSide');
          } else {
            parsedSide = ':{ $parsedSide }/{ ' + values.join(operator) + ' }';
          }
        }
      }
      _parsedSides[i] = parsedSide.trim();
      i++;
    });
    print('ParsedSides: $parsedSides');
    parseRaw(sides: parsedSides);
  }

  void multiply(List<String> values, {String operator = ' '}) {
    print('Multiplying with $values');
    bool containsAll = true;
    int i = 0;
    _parsedSides.forEach((parsedSide) {
      containsAll = true;
      values.forEach((string) {
        if (!parsedSide.contains(string)) {
          containsAll = false;
        }
      });
      if (containsAll) {
        //print('containsAll = true');
        scanForOperators(
            values: values.length == 1 ? values[0].split(' ') : values,
            i: i,
            start: _sidedValues[i].indexOf(values.first));

        parsedSide = _sidedValues[i].join(' ');
      } else {
        parsedSide = '$parsedSide * ' + values.join(operator);
      }
      _parsedSides[i] = parsedSide.trim();
      i++;
    });
    parseRaw(sides: parsedSides);
  }

  void subtract(List<String> values, {String operator = ' '}) {
    print('Subtracting with $values');
    bool containsAll = true;
    int i = 0;
    _parsedSides.forEach((parsedSide) {
      containsAll = true;
      values.forEach((string) {
        if (!parsedSide.contains(string)) {
          containsAll = false;
        }
      });
      if (containsAll) {
        scanForOperators(
            values: values.length == 1 ? values[0].split(' ') : values, i: i);
        parsedSide = _sidedValues[i].join(' ');
      } else {
        parsedSide = '$parsedSide - ' + values.join(operator);
      }
      _parsedSides[i] = parsedSide.trim();
      i++;
    });
    parseRaw(sides: parsedSides);
  }

  void add(List<String> values,
      {String operator = ' ', bool opIsNext = false}) {
    print('Adding with $values');
    bool containsAll = true;
    int i = 0;
    _parsedSides.forEach((parsedSide) {
      containsAll = true;
      values.forEach((string) {
        if (!parsedSide.contains(string)) {
          containsAll = false;
        }
      });
      if (containsAll) {
        scanForOperators(
            values: values.length == 1 ? values[0].split(' ') : values, i: i);
        parsedSide = _sidedValues[i].join(' ');
      } else {
        if (opIsNext)
          parsedSide = values.join(operator) + ' - $parsedSide';
        else
          parsedSide = '$parsedSide + ' + values.join(operator);
      }
      _parsedSides[i] = parsedSide.trim();
      i++;
    });
    parseRaw(sides: parsedSides);
  }

  void square({int power = 2, int side = 1}) {
    int i = 0;
    int count = 1;
    String powerS = '^$power';
    _parsedSides.forEach((parsedSide) {
      if (parsedSide.contains('√{') && parsedSide.contains('}')) {
        int closingBraceIndex;
        int openingBraceIndex = _sidedValues[i].indexOf('√{');
        for (int j = openingBraceIndex + 1; j < _sidedValues[i].length; j++) {
          if (_sidedValues[i][j].contains('}')) count--;
          if (_sidedValues[i][j].contains('{')) count++;
          if (count == 0)
            closingBraceIndex = j - 1;
          else
            print('SQUARE: closingIndex not found');
        }
        if (power > 2) {
          int powerIndex = openingBraceIndex - 1;
          _sidedValues[i].removeAt(powerIndex);
          openingBraceIndex--;
          closingBraceIndex--;
        }
        print('sidedValues: ${_sidedValues[i]}');
        print(
            'closingIndex: $closingBraceIndex | openingIndex $openingBraceIndex');
        _sidedValues[i].removeAt(openingBraceIndex);
        _sidedValues[i].removeAt(closingBraceIndex);
        parsedSide = _sidedValues[i].join(' ');
      } else {
        if (_sidedValues[i].length == 2)
          parsedSide = parsedSide + powerS;
        else
          parsedSide = '( $parsedSide )$powerS';
      }
      if (_sidedValues[i].contains('=')) _sidedValues[i].remove('=');
      _parsedSides[i] = parsedSide.trim();
      i++;
    });
    parseRaw(sides: parsedSides);
  }

  void root({int power = 2, bool rootResult = false}) {
    logcat('--take root with power $power and rootResult $rootResult');
    if (rootResult) {
      if (_sidedValues[0].first.contains('^')) {
        String val = _sidedValues[0].first;
        _sidedValues[0].first =
            val.replaceRange(val.indexOf('^'), val.length, '');
      }
      _sidedValues[1].insert(0, power == 2 ? '√{' : '^$power√{');
      _sidedValues[1].add('}');
      _parsedSides[0] = _sidedValues[0].join(' ');
      _parsedSides[1] = _sidedValues[1].join(' ');
    } else {
      int i = 0;
      int count = 1;
      _parsedSides.forEach((parsedSide) {
        if (parsedSide.contains('^' + power.toString())) {
          int squareIndex;
          int j = 0;
          _sidedValues[i].forEach((value) {
            if (value.contains('^' + power.toString())) {
              squareIndex = j;
            }
            j++;
          });
          if (_sidedValues[i][squareIndex - 1] == ')') {
            int closingBraceIndex = squareIndex - 1;
            int openingBraceIndex;
            for (int j = closingBraceIndex - 1; j >= 0; j--) {
              if (_sidedValues[i][j].contains('(')) count--;
              if (_sidedValues[i][j].contains(')')) count++;
              if (count == 0) openingBraceIndex = j;
            }
            _sidedValues[i].removeAt(openingBraceIndex);
            _sidedValues[i].removeAt(closingBraceIndex);
            squareIndex -= 2;
          }
          _sidedValues[i].removeAt(squareIndex);

          parsedSide = _sidedValues[i].join(' ');
        } else {
          if (power > 2)
            parsedSide = '^$power √{ $parsedSide }';
          else
            parsedSide = '√{ $parsedSide }';
        }
        if (_sidedValues[i].contains('=')) _sidedValues[i].remove('=');
        _parsedSides[i] = parsedSide.trim();
        i++;
      });
    }
    parseRaw(sides: parsedSides);
  }

  /// If the given side begins with a Trigonometric operator and ends with ']'
  /// then it will be taken away and the opposit will be put on the other side
  /// sin[a] = :{O}/{H} -> a = asin[:{O}/{H}]
  void switchSideOfBrackets({int fromSide = 1}) {
    logcat('Try switching side of [] of side $fromSide of $sidedValues');
    int toSide = fromSide == 1 ? 0 : 1;
    if (sidedValues[fromSide].first.contains('[') &&
        sidedValues[fromSide][sidedValues[fromSide].length - 2] == ']') {
      switch (sidedValues[fromSide].first) {
        case 'sin[':
          _sidedValues[toSide].insert(0, 'asin[');
          sidedValues[toSide].add(']');
          break;
        case 'cos[':
          sidedValues[toSide].insert(0, 'acos[');
          sidedValues[toSide].add(']');
          break;
        case 'tan[':
          sidedValues[toSide].insert(0, 'atan[');
          sidedValues[toSide].add(']');
          break;
        case 'asin[':
          sidedValues[toSide].insert(0, 'sin[');
          sidedValues[toSide].add(']');
          break;
        case 'acos[':
          sidedValues[toSide].insert(0, 'cos[');
          sidedValues[toSide].add(']');
          break;
        case 'atan[':
          sidedValues[toSide].insert(0, 'tan[');
          sidedValues[toSide].add(']');
          break;
      }
      sidedValues[fromSide].removeAt(0);
      sidedValues[fromSide].removeAt(sidedValues[fromSide].length - 2);
    } else {
      logcat('Failed switching side of []');
    }
  }

  void scanForOperators({List<String> values, int i, int start, int end}) {
    start ??= _sidedValues[i].indexOf(values.first);
    if (end == null) {
      if (values.first == '√{' || values.first == ':{') {
        end = findClosingIndex(start);
      } else if (values.first == '(') {
        end = findClosingIndex(start, type: '()');
      } else {
        //end = _sidedValues[i].length-1;
        end = start;
      }
    }

    logcat('---scanForOperators with values $values and i $i');
    logcat('   start $start');
    logcat('   end $end');
    List<int> removeAlso = [];

    if (!(start - 1 < 0)) {
      if (isCalcOperator(_sidedValues[i][start - 1])) {
        start--;
      }
    }

    // checks if denominator is empty
    if (!(start - 1 < 0 || _sidedValues[i].length < end + 1)) {
      if (_sidedValues[i][start - 1] == '}/{' &&
          _sidedValues[i][end + 1] == '}') {
        logcat('   checks for denominator');
        start -= 1;
        end += 1;
        int count = 1;
        for (int j = start - 1; j >= 0; j--) {
          if (_sidedValues[i][j].contains('}')) count++;
          if (_sidedValues[i][j].contains('{')) count--;
          if (count == 0) {
            removeAlso.add(j);
            j = -1;
          }
        }
        if (count < 0) throw FormatException('Closing brace was not found!');
        if (count > 0)
          throw FormatException('To many closing braces was found!');
      }

      // checks if numerator is empty
      if (_sidedValues[i][start - 1] == ':{' &&
          _sidedValues[i][end + 1] == '}/{') {
        logcat('   checks for numerator');
        start -= 1;
        end += 1;
        int count = 1;
        for (int j = end + 1; j < _sidedValues[i].length; j++) {
          if (_sidedValues[i][j].contains('{')) count++;
          if (_sidedValues[i][j].contains('}')) count--;
          if (count == 0) removeAlso.add(j);
        }
        if (count > 0) throw FormatException('Closing brace was not found!');
        if (count < 0)
          throw FormatException('To many closing braces was found!');
      }
    }

    logcat('   _sidedValues before cleaning: $_sidedValues');
    logcat('   removeAlso: $removeAlso');

    if (_sidedValues[i].contains('=')) _sidedValues[i].remove('=');
    if (start == end)
      _sidedValues[i].removeAt(start);
    else
      _sidedValues[i].removeRange(start, end + 1);
    if (removeAlso.length > 0) {
      int adjustIndex = end + 1 - start;
      removeAlso.forEach((index) {
        if (end < index) index -= adjustIndex;
        _sidedValues[i].removeAt(index);
        adjustIndex--;
      });
    }
  }

  bool isInBrace(String value) {
    if (!_values.contains('(')) return false;
    int i = _values.indexOf('(') + 1;
    int count = 1;
    while (true) {
      if (_values[i] == value) return true;
      if (_values[i].contains('(')) count++;
      if (_values[i].contains(')')) count--;
      if (count == 0) return false;
      i++;
    }
  }

  bool isInRoot(String value) {
    if (!_values.contains('√{')) return false;
    int i = _values.indexOf('√{') + 1;
    int count = 1;
    while (true) {
      if (_values[i] == value) return true;
      if (_values[i].contains('{')) count++;
      if (_values[i].contains('}')) count--;
      if (count == 0) return false;
      i++;
    }
  }

  bool isInDivider(String value, {int index, int side = 1}) {
    logcat('---isInDivider: find value $value with index $index');
    if (!_sidedValues[side].contains(':{')) return false;
    int i = index == null ? _sidedValues[side].indexOf(':{') + 1 : index + 1;
    int count = 1;
    while (true) {
      if (_sidedValues[side][i] == value) {
        logcat('   found value $value at $i');
        return true;
      }
      if (_sidedValues[side][i].contains('{') &&
          !_sidedValues[side][i].contains('}/{')) count++;
      if (_sidedValues[side][i].contains('}') &&
          !_sidedValues[side][i].contains('}/{')) count--;
      logcat(
          '   currently at i $i ((${_sidedValues[side][i]})) with count $count');
      if (count == 0) return false;
      i++;
    }
  }

  bool isNumerator(String value) {
    bool isTrue = false;
    _sidedValues.forEach((side) {
      if (side.contains(value)) {
        int i = side.indexOf('}/{') - 1;
        int count = 1;
        while (i >= 0) {
          if (side[i] == value) {
            isTrue = true;
            break;
          }
          if (side[i].contains('{')) count--;
          if (side[i].contains('}')) count++;
          if (count == 0) {
            isTrue = false;
            break;
          }
          i--;
        }
      }
    });
    return isTrue;
  }

  bool isSquare(String result) {
    if (_values.last == result) return false;

    int index = _values.indexOf(result);
    if (_values[index + 1].contains('^'))
      return true;
    else
      return false;
  }

  String next(String value, {bool variableOnly = false}) {
    int index = _values.indexOf(value);
    while (true) {
      index++;
      if (index > _values.length - 1) return null;
      if (variableOnly) {
        if (!isOperator(_values[index]))
          return _values[index];
        else
          continue;
      } else {
        return _values[index];
      }
    }
  }

  String prev(String value, {bool variableOnly = false}) {
    int index = _values.indexOf(value);
    while (true) {
      index--;
      if (index < 0) return value;
      if (variableOnly) {
        if (!isOperator(_values[index]))
          return _values[index];
        else
          continue;
      } else {
        return _values[index];
      }
    }
  }

  /// Returns if the given value is a operator
  static bool isOperator(String variable) => operators.contains(variable);
  static bool isCalcOperator(String variable) =>
      calcOperators.contains(variable);
  static bool isFriendlyOperator(String variable) =>
      friendlyOperators.contains(variable);

  static bool isGreekLetter(String variable) => greekLetters.contains(variable);

  static bool isConstant(String variable) => constants.contains(variable);

  /// All operators
  static final List<String> operators = [
    '+',
    '-',
    '*',
    '/',
    '√',
    '%',
    ':',
    '(',
    ')',
    '{',
    '}',
    '}/',
    '}/{',
    ':{',
    '√{',
    'sin[',
    'cos[',
    'tan[',
    'asin[',
    'acos[',
    'atan[',
    ']'
  ];

  static final List<String> greekLetters = [
    'alpha',
    'beta',
    'gamma',
    'delta',
    'epsilon',
    'zeta',
    'eta',
    'theta',
    'iota',
    'kappa',
    'lambda',
    'mu',
    'nu',
    'ksi',
    'omicron',
    'pi',
    'rho',
    'sigma',
    'tau',
    'ypsilanti',
    'phi',
    'chi',
    'omega'
  ];

  static final List<String> constants = ['pi'];

  /// Operators that should not be at the end
  static final List<String> calcOperators = ['+', '-', '*', '/', '%'];

  /// Operators that are allowed to fuse
  static final List<String> friendlyOperators = ['/', '√', ':', '}', '{', '}/'];
  static final List<String> fusedOperators = [':{', '√{', '}/{', '}/'];

  static String toCaTeXstatic(List<String> list) {
    String catex = '';
    list.forEach((variable) {
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

  String toCaTeX({List<String> value}) {
    value ??= _values;
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

  static final Map<String, String> _CaTeXvalues = {
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

class Parser {}
