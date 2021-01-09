import 'package:all_the_formulars/core/formula/formula2.dart';
import 'package:all_the_formulars/core/formula/units.dart';
import 'package:all_the_formulars/main.dart';

import 'formula_page.dart';
import 'formula_page_home.dart';

class IndustrialFormulas {
  static FormulaSubCategoryBase turningSubCategory = FormulaSubCategoryBase(
    name: L.string('turning'),
    data: [
      Item(
          formula: Formula2('v_f = n * f'),
          name: L.string('feed_rate'),
          meanings: [L.string('extended_length'), L.string('mean_coil_diameter'), L.string('resilient_coils')],
          units: ['mm', 'mm', Units.NONE]
      )
    ],
  );

  static FormulaSubCategoryBase placeholderSubCategory = FormulaSubCategoryBase(
    name: L.string('spring_wire_length'),
    data: [
      Item(
        formula: Formula2('l = pi * D_m * (i + 2)'),
        name: L.string('spring_wire_length'),
        meanings: [L.string('extended_length'), L.string('mean_coil_diameter'), L.string('resilient_coils')],
        units: ['mm', 'mm', Units.NONE]
      )
    ],
  );
}