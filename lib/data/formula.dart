import 'package:flutter/foundation.dart';

class Formulas {
  static List<Formula> _formulas = [];
  static _add(Formula formula) => _formulas.add(formula);
  static List<Formula> get all => _formulas;

  // area of triangle
  final Formula triangleArea = Formula(
      name: 'Triangle Area',
      description: 'Area of any Tryangle',
      category: FormulaCategory.math,
      formula: 'A = :{ g * h }/{ 2 }',
      defaultResult: 'A',
      changedFormulas: {
        'g': 'g = :{ A * 2 }/{ h }',
        'h': 'h = :{ A * 2 }/{ g }'
      });
}

enum FormulaCategory { math, physik }

class Formula {
  String name;
  String description;
  FormulaCategory category;
  String formula;
  String defaultResult;
  Map<String, String> changedFormulas;

  Formula({
    this.name,
    this.description,
    this.category,
    this.formula,
    this.defaultResult,
    this.changedFormulas,
  }) {
    assert(formula.contains(defaultResult));
    changedFormulas.keys.forEach((key) {
      assert(formula.contains(key));
    });
    Formulas._add(this);
  }

  String changeTo({@required String result}) => changedFormulas[result];

  double calculate(
      {@required String result, @required Map<String, double> values}) {}
}
