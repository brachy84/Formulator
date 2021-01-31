import 'package:flutter/material.dart';

import 'package:all_the_formulars/presentation/theme/colors.dart';

class Themes {
  static final ThemeData BRIGHT = ThemeData();

  static final ThemeData DARK = ThemeData(
      brightness: Brightness.dark,
      primaryColor: MoreColors.darkBlueGrey[700],
      canvasColor: MoreColors.darkBlueGrey[600],
      textTheme: TextTheme(bodyText2: TextStyle(color: Colors.grey[300])));
}
