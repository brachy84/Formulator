import 'package:flutter/foundation.dart';

class Formulas {
  static List<Formula> _formulas = [];
  static _add(Formula formula) => _formulas.add(formula);
  static List<Formula> get all => _formulas;

  // area of triangle
  static Formula triangleArea = const Formula(
      name: 'Triangle Area',
      description: 'Area of any Triangle',
      formula: 'A = :{ g * h }/{ 2 }',
      defaultResult: 'A',
      changedFormulas: {
        'g': 'g = :{ A * 2 }/{ h }',
        'h': 'h = :{ A * 2 }/{ g }'
      });

  static const List<FormulaBase> formulaData = [
    FormulaCategory(name: 'math', description: '', content: [
      FormulaCategory(name: 'geometry', description: '', content: [
        FormulaCategory(name: 'shapes', description: '', content: [
          FormulaCategory(name: 'square', description: '', content: [
            Formula(
                name: 'area',
                description: 'square_area_desc',
                formula: 'A = a^2',
                defaultResult: 'A',
                changedFormulas: {'a': 'a = √{ A }'}),
            Formula(
                name: 'perimeter',
                description: 'square_perimeter_desc',
                formula: 'U = 4a',
                defaultResult: 'U',
                changedFormulas: {'a': 'a = :{ U }/{ 4 }'}),
          ]),
          FormulaCategory(name: 'rectangle', description: '', content: [
            Formula(
                name: 'area',
                description: 'rectangle_area_desc',
                formula: 'A = a * b',
                defaultResult: 'A',
                changedFormulas: {
                  'a': 'a = :{ A }/{ b }',
                  'b': 'b = :{ A }/{ a }'
                }),
            Formula(
                name: 'perimeter',
                description: 'rectangle_perimeter_desc',
                formula: 'U = 2a + 2b',
                defaultResult: 'U',
                changedFormulas: {
                  'a': 'a = :{ U - 2b }/{ 2 }',
                  'b': 'b = :{ U - 2a }/{ 2 }'
                }),
          ])
        ]),
        FormulaCategory(name: 'bodys', description: '', content: [])
      ]),
      FormulaCategory(name: 'phytagoras', description: '', content: []),
      FormulaCategory(name: 'trigonometry', description: '', content: [])
    ]),
    FormulaCategory(name: 'physic', description: '', content: [])
  ];
}

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
  final String formula;
  final String defaultResult;
  final Map<String, String> changedFormulas;

  const Formula({
    @required String name,
    @required String description,
    @required this.formula,
    @required this.defaultResult,
    @required this.changedFormulas,
  }) : super(name: name, description: description);
  /* {
    assert(formula.contains(defaultResult));
    changedFormulas.keys.forEach((key) {
      assert(formula.contains(key));
    });
    Formulas._add(this);
  }*/

  String changeTo({@required String result}) => changedFormulas[result];

  double calculate(
      {@required String result, @required Map<String, double> values}) {}
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
