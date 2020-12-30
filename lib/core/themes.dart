import 'dart:ui';

import 'package:all_the_formulars/core/utils.dart';
import 'file:///C:/Users/Joel/AndroidStudioProjects/all_the_formulars/lib/Settings.dart';
import 'package:all_the_formulars/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Themes {

  static ThemeData setTheme(ThemeData theme, {Color accent, Color primary}) {
    if(accent == null) {
      logcat('  accent was NULL');
    }
    if(primary == null){
      logcat('  primary was NULL');
    }
    logcat('getTheme: $theme');
    ThemeData newTheme = theme.copyWith(accentColor: accent, primaryColor: primary);
    appliedTheme = newTheme;
    switch(theme.brightness) {
      case Brightness.light :
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: appliedTheme.primaryColor,
            systemNavigationBarIconBrightness: Brightness.dark
        ));
        break;
      case Brightness.dark :
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: appliedTheme.primaryColor
        ));
        break;
    }
    return newTheme;
  }

  static getFormulaColor() {
    switch(Settings.selectValue) {
      case 0 :
        return Colors.grey[300]; break;
      case 1 :
        return Colors.grey[850]; break;
      case 2 :
        return Colors.yellow[300]; break;
      case 3 :
        return Colors.lightBlueAccent; break;
      default :
        return Colors.grey[850];
    }
  }

  /// Default Theme
  /// selectValue 0
  static ThemeData get defaultTheme => _defaultTheme;
  static final ThemeData _defaultTheme = ThemeData(
    accentColor: Colors.deepOrangeAccent,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// Dark Theme
  /// selectValue 1
  static ThemeData get darkTheme => _darkTheme;
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.deepOrangeAccent,
    primaryColorLight: Colors.grey[700],
  );

  /// Warm Theme
  /// selectValue 2
  static ThemeData get warmTheme => _warmTheme;
  static final ThemeData _warmTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.red[600],
    primaryColorLight: Colors.red[400],
    primaryColorDark: Colors.red[800],
    accentColor: Colors.yellowAccent,
    canvasColor: Colors.orange[300],
    cardColor: Colors.orangeAccent[100]
  );

  /// Cold Theme
  /// selectValue 3
  static ThemeData get coldTheme => _coldTheme;
  static final ThemeData _coldTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue[600],
      primaryColorLight: Colors.blue[400],
      primaryColorDark: Colors.blue[800],
      accentColor: Colors.orangeAccent,
      canvasColor: Colors.lightBlue[200],
      cardColor: Colors.lightBlue[100]
  );

  static List<ThemeData> themes = [
    _defaultTheme,
    _darkTheme,
    _warmTheme,
    _coldTheme
  ];

}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData getTheme() => _themeData;

  setTheme(ThemeData themeData, {Color accent, Color primary}) async {
    accent ??= themeData.accentColor;
    primary ??= themeData.primaryColor;
    _themeData = Themes.setTheme(themeData, accent: accent, primary: primary);
    logcat(_themeData);
    notifyListeners();
  }
}