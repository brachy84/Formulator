import 'file:///C:/Users/Joel/AndroidStudioProjects/all_the_formulars/lib/core/system/storage.dart';
import 'package:all_the_formulars/core/themes.dart';
import 'package:all_the_formulars/core/utils.dart';
import 'package:all_the_formulars/core/widgets.dart';
import 'package:all_the_formulars/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings {
  static Color currentAccent = appliedTheme.accentColor;
  static Color currentPrimary = appliedTheme.primaryColor;
  static bool defaultAccent = true;
  static bool defaultPrimary = true;
  static int selectValue;
  //double sliderValue = 500;
  //int colorShade = 100;
  static int colorIndexAccent;
  static int colorIndexPrimary;

  static List<Color> accentList = List.of(Colors.accents, growable: true);
  static List<Color> primaryList = List.of(Colors.primaries, growable: true);
  static List<Color> greyShades = [Colors.grey[300], Colors.grey[500], Colors.grey[700], Colors.grey[800],
    Colors.grey[850], Colors.grey[900], Colors.black];

  static void initTheme() async {
    selectValue = await SaveData.readData('THEME_INDEX');
    selectValue ??= 1;
    accentList.addAll(greyShades);
    primaryList.addAll(greyShades);
    accentList.insert(0, Themes.themes[selectValue].accentColor);
    primaryList.insert(0, Themes.themes[selectValue].primaryColor);
    //await SaveData.saveDataInit();
    colorIndexPrimary = await SaveData.readData('PRIMARY_INDEX');
    colorIndexAccent = await SaveData.readData('ACCENT_INDEX');
    selectValue = await SaveData.readData('THEME_INDEX');
    colorIndexPrimary ??= 24;
    colorIndexAccent ??= 16;
    selectValue ??= 1;
    appliedTheme = Themes.themes[selectValue];
    FormularApp.themeNotifier.setTheme(appliedTheme, primary: primaryList[colorIndexPrimary], accent: accentList[colorIndexAccent]);
  }
}

class SettingsHome extends StatefulWidget {
  @override
  _SettingsHome createState() => _SettingsHome();
}

class _SettingsHome extends State<SettingsHome> {

  @override
  void initState() {
    logcat('--INIT STATE--');
    super.initState();
  }

  @override
  void dispose() {
    logcat('--DISPOSE--');
    SaveData.saveData('THEME_INDEX', Settings.selectValue);
    SaveData.saveData('ACCENT_INDEX', Settings.colorIndexAccent);
    SaveData.saveData('PRIMARY_INDEX', Settings.colorIndexPrimary);
    super.dispose();
  }

  Widget getHeader(String title) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 8),
          child: Text(title, style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),)
      ),
    );
  }

  Widget getSettingCard({String header, List<Widget> children}) {
    children.insert(0, getHeader(header));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 10,
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        children: children,
      ),
    );
  }

  void onThemeChange(int value, ThemeNotifier themeNotifier) {
    setState(() {
      Settings.selectValue = value;
      Settings.currentAccent = Settings.colorIndexAccent == 0 ? Themes.themes[value].accentColor : Settings.currentAccent;
      Settings.currentPrimary = Settings.colorIndexPrimary == 0 ? Themes.themes[value].primaryColor : Settings.currentPrimary;
      Settings.accentList[0] = Settings.currentAccent;
      Settings.primaryList[0] = Settings.currentPrimary;
      themeNotifier.setTheme(Themes.themes[value], accent: Settings.currentAccent, primary: Settings.currentPrimary);
    });
  }

  @override
  Widget build(BuildContext context) {
    logcat('Building');
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('settings')),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: ListView(
          children: [
            getSettingCard(header: L.string('colorSettings'),
                children: [
                  ListTile(
                    leading: ColorPicker(
                      currentColor: Settings.currentAccent,
                      initColorIndex: Settings.colorIndexAccent,
                      colorList: Settings.accentList,
                      onDone: (color, index) {
                        setState(() {
                          Settings.defaultAccent = false;
                          Settings.currentAccent = color;
                          Settings.colorIndexAccent = index;
                          themeNotifier.setTheme(appliedTheme, accent: Settings.currentAccent);
                        });
                      },
                    ),
                    title: Text(L.string('accent')),
                    trailing: FlatButton(
                      child: Text(L.string('useDefault'), style: TextStyle(fontWeight: FontWeight.w300),),
                      onPressed: () {
                        setState(() {
                          Settings.defaultAccent = true;
                          Settings.colorIndexAccent = 0;
                          Settings.currentAccent = Themes.themes[Settings.selectValue].accentColor;
                          themeNotifier.setTheme(appliedTheme, primary: Settings.currentPrimary, accent: Settings.currentAccent);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: ColorPicker(
                      currentColor: Settings.currentPrimary,
                      initColorIndex: Settings.colorIndexPrimary,
                      colorList: Settings.primaryList,
                      onDone: (color, index) {
                        setState(() {
                          Settings.defaultPrimary = false;
                          Settings.currentPrimary = color;
                          Settings.colorIndexPrimary = index;
                          themeNotifier.setTheme(appliedTheme, primary: Settings.currentPrimary);
                        });
                      },
                    ),
                    title: Text(L.string('primary')),
                    trailing: FlatButton(
                      child: Text(L.string('useDefault'), style: TextStyle(fontWeight: FontWeight.w300),),
                      onPressed: () {
                        setState(() {
                          Settings.defaultPrimary = true;
                          Settings.colorIndexPrimary = 0;
                          Settings.currentPrimary = Themes.themes[Settings.selectValue].primaryColor;
                          themeNotifier.setTheme(appliedTheme, accent: Settings.currentAccent, primary: Settings.currentPrimary);
                        });
                      },
                    ),
                  ),
                ]
            ),
            getSettingCard(header: L.string('themeSettings'),
            children: [
              RadioListTile(
                title: Text(L.string('bright')),
                value: 0,
                groupValue: Settings.selectValue,
                onChanged: (value) {
                  onThemeChange(value, themeNotifier);
                },
              ),
              RadioListTile(
                title: Text(L.string('dark')),
                value: 1,
                groupValue: Settings.selectValue,
                onChanged: (value) {
                  onThemeChange(value, themeNotifier);
                },
              ),
              RadioListTile(
                title: Text(L.string('warm')),
                value: 2,
                groupValue: Settings.selectValue,
                onChanged: (value) {
                  onThemeChange(value, themeNotifier);
                },
              ),
              RadioListTile(
                title: Text(L.string('cold')),
                value: 3,
                groupValue: Settings.selectValue,
                onChanged: (value) {
                  onThemeChange(value, themeNotifier);
                },
              ),
            ]
            ),
            //getSettingCard(header: loc.string('languageSettings'),
            //  children: []),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: null,
        backgroundColor: appliedTheme.accentColor,
      ),
    );
  }
}
