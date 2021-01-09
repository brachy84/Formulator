import 'dart:math';

import 'package:all_the_formulars/core/utils.dart';
import 'package:flutter/cupertino.dart';

import 'formula2.dart';

class Calculate {
  Formula2 calcFormula;

  Calculate({@required this.calcFormula});

  bool hasSimpleMultiplicator(List<String> formula) {
    List<String> copy = List.of(formula);
    while (copy.contains('*')) {
      int index = copy.indexOf('*');
      if (Utils.isNumeric(copy[index - 1]) &&
          Utils.isNumeric(copy[index + 1])) {
        return true;
      } else {
        copy[index] = '#';
      }
    }
    return false;
  }

  /// New! Try's to calculate lines. Should only have '*' and '-' / '+' as operators
  Map<List<String>, int> calcBase(List<String> formula) {
    int diff = formula.length;
    logcat('  calc formula: $formula');
    if (formula.length >= 3 &&
        formula.length % 2 == 1 &&
        !Formula2.isOperator(formula[0]) &&
        !Formula2.isOperator(formula[2])) {
      logcat('  calc');
      while (formula.length > 1) {
        if (formula.contains('*') && formula[1] != '*') {
          logcat('  contains * but is not first operator');
          if (hasSimpleMultiplicator(formula)) {
            formula = solveMultiplications(formula);
          }
        }
        switch (formula[1]) {
          case '+':
            formula.replaceRange(0, 3, [
              (double.parse(formula[0]) + double.parse(formula[2])).toString()
            ]);
            break;
          case '-':
            formula.replaceRange(0, 3, [
              (double.parse(formula[0]) - double.parse(formula[2])).toString()
            ]);
            break;
          case '*':
            formula.replaceRange(0, 3, [
              (double.parse(formula[0]) * double.parse(formula[2])).toString()
            ]);
            break;
          default:
            throw FormatException('Second position was not *, + or -.');
          //case '' :
        }
      }
    } else {
      logcat('Calc: Did not match requirements');
    }
    diff -= formula.length;
    return {formula: diff};
  }

  /// Solves [] (Only Trigonometric for now)
  List<String> solveBrackets(List<String> formula) {
    logcat('Try solving brackets [] of $formula');
    if (formula.contains(']')) {
      for (int i = 0; i < formula.length; i++) {
        if (formula[i].contains('[')) {
          if (formula[i + 2] == ']') {
            String operation = formula[i].substring(0, formula[i].indexOf('['));
            double num = double.parse(formula[i + 1]);
            switch (operation) {
              case 'sin':
                formula[i + 1] = sin(Utils.toRad(num)).toString();
                break;
              case 'cos':
                formula[i + 1] = cos(Utils.toRad(num)).toString();
                break;
              case 'tan':
                formula[i + 1] = tan(Utils.toRad(num)).toString();
                break;
              case 'asin':
                formula[i + 1] = Utils.toDeg(asin(num)).toString();
                break;
              case 'acos':
                formula[i + 1] = Utils.toDeg(acos(num)).toString();
                break;
              case 'atan':
                formula[i + 1] = Utils.toDeg(atan(num)).toString();
                break;
              default:
                logcat('Could not find trigonometric operator!');
            }
            formula.removeAt(i); // sin[
            assert(formula[i + 1] == ']');
            formula.removeAt(i + 1); // ]
          } else {
            List<String> braceContent = formula
                .getRange(i + 1,
                    calcFormula.findClosingIndex(i, type: '[]', list: formula))
                .toList();
            braceContent = solveMultiplications(braceContent);
            braceContent = solveCurlyBrace(braceContent);
            braceContent = dissolveCurlyBrace(braceContent);
            logcat('Try calc from solveBrackets');
            braceContent = calcBase(braceContent).keys.first;
            formula.replaceRange(
                i + 1,
                calcFormula.findClosingIndex(i, type: '[]', list: formula),
                braceContent);
            solveBrackets(formula);
          }
        }
      }
    }
    return formula;
  }

  ///Solves (). Now all () should be gone.
  List<String> solve(List<String> formula, {bool isNested = false}) {
    logcat('Try solving () of $formula');
    logcat(
        '  solveBrace with formula (calc step4): $formula | isNested: $isNested');

    /// //////////////////////////////////////////
    while (formula.contains('(')) {
      List<String> braceContent = List.of(formula, growable: true);

      /// true for Divide and false for root
      int recOut = 0;
      while (braceContent.contains('(')) {
        for (int i = 0; i < formula.length; i++) {
          if (formula[i] == '(') {
            braceContent = formula
                .getRange(i + 1,
                    calcFormula.findClosingIndex(i, list: formula, type: '()'))
                .toList();
            break;
          }
        }
      }

      Calculate calculator =
          Calculate(calcFormula: Formula2('#AP = ' + braceContent.join(' ')));
      braceContent = calculator.solve(braceContent);
      braceContent = calculator.solveMultiplications(braceContent);
      braceContent = calculator.solveCurlyBrace(braceContent);
      braceContent = calculator.dissolveCurlyBrace(braceContent);
      braceContent = calculator.calcBase(braceContent).keys.first;
      if (braceContent.length > 1) {
        logcat('ROUND ONE OVER : $braceContent');
        braceContent = calculator.solveMultiplications(braceContent);
        braceContent = calculator.solveCurlyBrace(braceContent);
        braceContent = calculator.dissolveCurlyBrace(braceContent);
        braceContent = calculator.calcBase(braceContent).keys.first;
      }

      logcat('  braceContent (): $braceContent');
      logcat('  formula before replacing: $formula');
      if (formula.contains('(')) {
        logcat('    has (');
        for (int i = 0; i < formula.length; i++) {
          if (formula[i] == '(') {
            logcat('    found (');
            formula.replaceRange(
                i,
                calcFormula.findClosingIndex(i, list: formula, type: '()') + 1,
                braceContent);
            break;
          }
        }
      } else {
        formula = braceContent;
      }
      /*if(isNested) {
        logcat('  start recalc values');
        logcat('Try calc from dissolveCurlyBrace');
        formula = calcBase(formula).keys.first;
      }*/
      logcat(' formula before return: $formula');
    }

    /// ///////////////////////////////////////////
    return formula;
  }

  /// Solves <> Was set in [_parseForCalc()] around '*'
  List<String> solveMultiplications(List<String> formula) {
    logcat('Try solving <> of $formula');
    formula = calcFormula.parseForCalc(formula);
    logcat('  step 2 beginn with: $formula');
    List<String> braceContent = List.of(formula, growable: true);
    while (formula.contains('<')) {
      if (formula.contains('<')) {
        braceContent = formula
            .getRange(
                formula.indexOf('<') + 1,
                calcFormula.findClosingIndex(formula.indexOf('<'),
                    type: '<>', list: formula))
            .toList();
        /*
        while(braceContent.contains('<')) {
          logcat('  has <');
          braceContent = solveMultiplications(braceContent);
          //formula.replaceRange(formula.indexOf('('), findClosingIndex(formula.indexOf('(')+1, type: '()', list: formula), solveBrace2(braceContent));
        }
         */
      }
      logcat('Try calc from solveMultiplications');
      braceContent = calcBase(braceContent).keys.first;

      logcat('----solveMultiplikation');
      if (formula.contains('<')) {
        for (int i = 0; i < formula.length; i++) {
          if (formula[i] == '<') {
            logcat('    found < at $i');
            logcat('    formula before replacing: $formula');
            formula.replaceRange(
                i,
                calcFormula.findClosingIndex(i, type: '<>', list: formula) + 1,
                braceContent);
            logcat('    formula after replacing: $formula');
            break;
          }
        }
      } else {
        logcat('    Did not found <');
        formula = braceContent;
      }
    }
    while (hasSimpleMultiplicator(formula)) {
      logcat('    --formula in iterator before: $formula');
      formula = solveMultiplications(formula);
      logcat('    --formula in iterator after: $formula');
    }
    logcat('----returning $formula');
    return formula;
  }
/*
  calcValues = solveBrace(calcValues);
  while(calcValues.contains('<')) {
  calcValues = solveBrace(calcValues);
  calcValues = _parseForCalc(calcValues);
  }

 */

  ///Solves inside {}. After this only one number should be in each {}
  List<String> solveCurlyBrace(List<String> formula) {
    logcat('Try solving inside curly Brace {} of $formula');
    List<String> braceContent = List.of(formula, growable: true);
    Map<List<String>, int> formulaWithDiff;
    if (formula.contains(':{') || formula.contains('√{')) {
      for (int i = 0; i < formula.length; i++) {
        if (formula[i].contains('{')) {
          if (formula[i] == ':{') {
            braceContent = formula
                .getRange(
                    i + 1,
                    calcFormula.findClosingIndex(i,
                        findMidOperator: true, list: formula))
                .toList();
          } else if (formula[i] == '}/{' || formula[i] == '√{') {
            braceContent = formula
                .getRange(i + 1, calcFormula.findClosingIndex(i, list: formula))
                .toList();
          }
          if (braceContent.length >= 3 &&
              !braceContent.contains(':{') &&
              !braceContent.contains('√{') &&
              !braceContent.contains('}/{')) {
            //while(braceContent.length > 1) {
            logcat('Try calc from solveCurlyBrace');
            formulaWithDiff = calcBase(braceContent);
            braceContent = formulaWithDiff.keys.first;
            //}
          }
          if (formula[i] == ':{') {
            formula.replaceRange(
                i + 1,
                calcFormula.findClosingIndex(i,
                    findMidOperator: true, list: formula),
                braceContent);
          } else if (formula[i] == '}/{' || formula[i] == '√{') {
            formula.replaceRange(i + 1,
                calcFormula.findClosingIndex(i, list: formula), braceContent);
          }
          if (formulaWithDiff != null) {
            i -= formulaWithDiff.values.first - 1;
          }
        }
      }
    }
    return formula;
  }

  ///Solves {}. Now all {} should be gone.
  List<String> dissolveCurlyBrace(List<String> formula,
      {bool isNested = false}) {
    logcat('Try solving Divide and Root of $formula');
    logcat(
        '  solveBrace with formula (calc step4): $formula | isNested: $isNested');

    /// //////////////////////////////////////////
    while (formula.contains(':{') || formula.contains('√{')) {
      List<String> braceContent = List.of(formula, growable: true);

      /// true for Divide and false for root
      bool isDivide = true;
      int recOut = 0;
      while (braceContent.contains(':{') || braceContent.contains('√{')) {
        for (int i = 0; i < formula.length; i++) {
          if (formula[i] == ':{') {
            braceContent = formula
                .getRange(i + 1, calcFormula.findClosingIndex(i, list: formula))
                .toList();
            isDivide = true;
            break;
          } else if (formula[i] == '√{') {
            braceContent = formula
                .getRange(i + 1, calcFormula.findClosingIndex(i, list: formula))
                .toList();
            isDivide = false;
            break;
          }
        }
        int recIn = 0;
        while (braceContent.contains(':{') || braceContent.contains('√{')) {
          logcat('  has {');
          braceContent = dissolveCurlyBrace(braceContent, isNested: true);
          //formula.replaceRange(formula.indexOf('('), findClosingIndex(formula.indexOf('(')+1, type: '()', list: formula), solveBrace2(braceContent));
          recIn++;
          logcat('  Innerloop: $recIn');
          logcat('  braceContent: $braceContent');
        }
        recOut++;
        logcat('  Outerloop: $recOut');
        logcat('  braceContent: $braceContent');
      }

      if (isDivide) {
        logcat(' now dividing / braceContent: $braceContent');
        logcat(
            '  double top: ${braceContent.getRange(0, braceContent.indexOf('}/{')).join(' ')}');
        logcat(
            '  double bottom: ${braceContent.getRange(braceContent.indexOf('}/{') + 1, braceContent.length).join(' ')}');
        braceContent = [
          (double.parse(braceContent
                      .getRange(0, braceContent.indexOf('}/{'))
                      .join(' ')) /
                  double.parse(braceContent
                      .getRange(
                          braceContent.indexOf('}/{') + 1, braceContent.length)
                      .join(' ')))
              .toString()
        ];
      } else if (!isDivide) {
        logcat(' now rooting / braceContent: $braceContent');
        braceContent = [
          sqrt(double.parse(
                  braceContent.getRange(0, braceContent.length).join(' ')))
              .toString()
        ];
      }

      logcat('  braceContent after divide/root: $braceContent');
      logcat('  formula before replacing: $formula');
      if (formula.contains(':{') || formula.contains('√{')) {
        logcat('    has :{ / √{');
        for (int i = 0; i < formula.length; i++) {
          if (formula[i] == ':{' || formula[i] == '√{') {
            logcat('    found :{ / √{');
            formula.replaceRange(
                i,
                calcFormula.findClosingIndex(i, list: formula) + 1,
                braceContent);
            break;
          }
        }
      } else {
        formula = braceContent;
      }
      if (isNested) {
        logcat('  start recalc values');
        logcat('Try calc from dissolveCurlyBrace');
        formula = calcBase(formula).keys.first;
      }
      logcat(' formula before return: $formula');
    }

    /// ///////////////////////////////////////////
    return formula;
  }
}
