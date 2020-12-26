import 'package:all_the_formulars/core/formula/formula2.dart';

import 'formula_page.dart';
import 'formula_page_home.dart';

class IndustrialFormulas {
  static FormulaSubCategoryBase placeholderSubCategory = FormulaSubCategoryBase(
    name: 'placeholder',
    data: [
      Item(
        formula: Formula('A = b'),
        name: 'placeholder',
        meanings: ['a', 'B'],
        units: ['m', 'm']
      )
    ],
  );
}