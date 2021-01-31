import 'package:flutter/material.dart';

extension MoreColors on Colors {
  static const int _darkBlueGreyPrimaryValue = 0xFF263238;
  static const MaterialColor darkBlueGrey = MaterialColor(
    MoreColors._darkBlueGreyPrimaryValue,
    <int, Color>{
      50: Color(0xFFECEFF1),
      100: Color(0xFFCFD8DC),
      200: Color(0xFFB0BEC5),
      300: Color(0xFF90A4AE),
      400: Color(0xFF78909C),
      500: Color(MoreColors._darkBlueGreyPrimaryValue),
      600: Color(0xFF1d272b),
      700: Color(0xFF182024),
      800: Color(0xFF161e21),
      900: Color(0xFF13191c),
    },
  );

  static const int _darkBlueGreenPrimaryValue = 0xFF0a2d3d;
  static const MaterialColor darkBlueGreen = MaterialColor(
    MoreColors._darkBlueGreenPrimaryValue,
    <int, Color>{
      50: Color(0xFF135370),
      100: Color(0xFF104861),
      200: Color(0xFF0e3c52),
      300: Color(0xFF0c384d),
      400: Color(0xFF0b3142),
      500: Color(MoreColors._darkBlueGreenPrimaryValue),
      600: Color(0xFF082530),
      700: Color(0xFF061f29),
      800: Color(0xFF061d26),
      900: Color(0xFF051921),
    },
  );
}
