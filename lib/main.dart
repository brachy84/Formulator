import 'dart:math';

import 'package:all_the_formulars/Settings.dart';
import 'package:all_the_formulars/constants.dart';
import 'package:all_the_formulars/core/system/webdata.dart';
import 'package:all_the_formulars/core/themes.dart';
import 'package:all_the_formulars/core/utils.dart';
import 'package:all_the_formulars/formulas_category/formula_page_home.dart';
import 'package:all_the_formulars/unit_convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'core/system/Localization.dart';
import 'core/system/storage.dart';

///Declare Global vars
final _themeGlobalKey = new GlobalKey(debugLabel: 'app_theme');
final Localization _loc = Localization();
Localization get L => _loc;
bool versionChecked = false;
JsonSetup _json;
JsonSetup get jsonFile => _json;

bool isInitialized = false;

ThemeData _appliedTheme;
set appliedTheme(ThemeData theme) {
  _appliedTheme = theme;
}

ThemeData get appliedTheme => _appliedTheme;

void main() async {
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(Themes.darkTheme), child: FormularApp()));
  Settings.initTheme();
}

Future<bool> init() async {
  await Localization.init();
  if (!isInitialized) {
    isInitialized = true;
    await WebData.initCurrencyExchange();
    await Future.delayed(Duration(
        milliseconds: Const
            .SPLASH_SCREEN_TIMER)); // Timer so the splash screen stays longer
  }
  return true;
}

class FormularApp extends StatelessWidget {
  // This widget is the root of your application.

  static ThemeNotifier _themeNotifier;
  static ThemeNotifier get themeNotifier => _themeNotifier;

  @override
  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'All the Formulas',
      theme: themeNotifier.getTheme(),
      //darkTheme: Themes.darkTheme,
      home: AppHome(title: 'All the Formulas'),
    );
  }
}

class AppHome extends StatefulWidget {
  AppHome({Key key, this.title}) : super(key: _themeGlobalKey);

  final String title;

  @override
  _AppHome createState() => _AppHome();
}

class _AppHome extends State<AppHome> {
  Widget homeWidget = Const.SHOW_AUTHOR
      ? Scaffold(
          body: Container(
            color: Colors.grey[850],
            constraints: BoxConstraints(
                minHeight: double.infinity, minWidth: double.infinity),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Image(
                    image: AssetImage('assets/icon/atf_icon512.png'),
                    width: 150,
                    height: 150,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Text('by',
                      style: TextStyle(fontSize: 22, color: Colors.grey[600])),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Text('brachy84',
                      style: TextStyle(fontSize: 22, color: Colors.grey[600])),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            //child: Center(child: Text('Loading language'),),
          ),
        )
      : Scaffold(
          body: Container(
            color: Colors.grey[850],
            constraints: BoxConstraints(
                minHeight: double.infinity, minWidth: double.infinity),
            child: Center(
              child: Image(
                image: AssetImage('assets/icon/atf_icon512.png'),
                width: 150,
                height: 150,
              ),
            ),
          ),
        );

  @override
  void initState() {
    /// Initialize Shared Preferences
    //SaveData.readAll();

    /// Initialize Custom Items
    _json = JsonSetup(fileName: 'custom_item.json');
    Item.initCustomItems();

    super.initState();
    timeDilation = 1.5;
  }

  @override
  void dispose() {
    super.dispose();
    timeDilation = 1;
  }

  TextEditingController controller = TextEditingController();
  String result = '?';

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    //screenSize = Size(400, 800);
    screenDiagonal =
        Utils.dp(sqrt(pow(screenSize.width, 2) + pow(screenSize.height, 2)), 3);
    print('Screensize ${screenSize.width} x ${screenSize.height}');
    print('ScreenDiagonal $screenDiagonal');
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          getBuilded(context);
        }
        return AnimatedSwitcher(
            duration: Duration(seconds: 1),
            switchInCurve: Curves.easeIn,
            child: homeWidget);
      },
    );
  }

  Future<void> getBuilded(BuildContext context) async {
    //await Future.delayed(Duration(seconds: 1));
    homeWidget = DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(L.string('app_name')),
              bottom: TabBar(
                indicatorColor: appliedTheme.accentColor,
                tabs: [
                  Tab(text: L.string('converter')),
                  Tab(text: L.string('formulas'))
                ],
              ),
              actions: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.slidersH),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsHome()));
                  },
                )
              ],
            ),
            body: TabBarView(children: [
              UnitConvertHome.getUnitConvertHome(context),
              FormulaHome.getFormulaHome(context),
            ])));
  }

  Future<bool> future() async => true;
}
