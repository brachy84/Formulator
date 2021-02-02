// launch old main.dart
import 'package:all_the_formulars/buisness_logic/conversion_bloc.dart';
import 'package:all_the_formulars/buisness_logic/currency_bloc.dart';
import 'package:all_the_formulars/buisness_logic/formula_bloc.dart';
import 'package:all_the_formulars/buisness_logic/theme_bloc.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/old/main.dart' as OldMain;
import 'package:all_the_formulars/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // runs the old app
  //OldMain.main();

  // runs the new App
  runApp(FormulaApp());
}

bool hasInternetConnection;
final themeBloc = ThemeBloc();

class FormulaApp extends StatelessWidget {
  const FormulaApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      cubit: themeBloc,
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'All the Formulas',
          theme: state.theme,
          supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
          localizationsDelegates: [
            LocaleBase.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            return supportedLocales.firstWhere(
              (supportedLocale) =>
                  supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode,
              orElse: () => Locale('en', 'US'),
            );
          },
          home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ThemeBloc()),
              BlocProvider(create: (_) => ConversionBloc()),
              BlocProvider(create: (_) => FormulaBloc()),
              BlocProvider(create: (_) => CurrencyBloc())
            ],
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}
