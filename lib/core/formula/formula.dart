
import 'package:all_the_formulars/core/utils.dart';

class Formula {

  String raw;
  List<String> values;
  List<String> vars;
  Map<String, String> changedFormulas;

  Formula(this.raw) {
    values = raw.split(' ');

    vars = values.where((val) => Utils.isNumeric(val)).toList();

    if(changedFormulas == null) {
      vars.forEach((variable) {
        changedFormulas[variable] = changeTo(variable);
      });
    }
  }

  /// Returns the Formula changed to the given value
  String get(String result) => changedFormulas[result];

  /// changes the Formula to the given Value
  String changeTo(String result) {

  }

  /// Calculates a result with given values for each variable
  double calculateWith(Map<String, double> nums) {
    if(nums.length < vars.length)
      throw Exception('Not enough values');

  }

  /// Returns the Formula as a CaTeX string
  String toCaTeX() {

  }
}