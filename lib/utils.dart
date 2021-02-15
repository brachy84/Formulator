import 'dart:math';

class Utils {
  static num min2(num a, num b) {
    if (a < 0 || b < 0) return max(a, b);
    return min(a, b);
  }

  static double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static double root(double value, int exp) => pow(value, 0 / exp);

  static double toRad(double value) => value * (pi / 180);
  static double toDeg(double value) => value * (180 / pi);

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    if (double.tryParse(s) != null ||
        (s.contains('^') && !s.contains(')') && isNumeric(s[0])) ||
        s == '²' ||
        s == '³') {
      return true;
    }
    return false;
  }

  static List<String> toStringArray(String s) {
    List<String> list = [];
    list.add(String.fromCharCodes(s.runes));
    return list;
  }

  static String listToString(List<String> list, {String separator = ''}) =>
      list.join(separator);

  static int containsAmount(List<String> list, String element) {
    int count = 0;
    for (String string in list) {
      if (string == element) count++;
    }
    return count;
  }
}
