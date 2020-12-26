import 'dart:ui';

import 'file:///C:/Users/Joel/AndroidStudioProjects/all_the_formulars/lib/core/formula/formula2.dart';
import 'package:all_the_formulars/core/formula/units.dart';
import 'package:all_the_formulars/core/themes.dart';
import 'package:all_the_formulars/core/utils.dart';
import 'package:all_the_formulars/formulas_category/formula_page_home.dart';
import 'package:all_the_formulars/formulas_category/math_formulas.dart';
import 'package:catex/catex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ColorPicker extends StatefulWidget {

  Widget child;
  Color currentColor;
  int initColorIndex;
  List<Color> colorList;
  Function(Color color, int index) onChanged;
  @required Function(Color color, int index) onDone;

  /// Creates a clickable [CircleAvatar]
  /// to let the user choose a color
  ///
  /// [child] is what is displayed when [ColorPicker] is closed
  /// default is a colored circle
  /// [currentColor] is the initial color of [CircleAvatar]
  /// default is [Colors.deepOrangeAccent]
  /// [colorList] is the List the user can choose from
  /// default is [Colors.primaries]
  /// [onChanged] gets called when user taps on a color
  /// it has [Color] and [int] ([colorList] index) as parameter
  ColorPicker({this.currentColor, this.initColorIndex, this.onChanged, this.onDone, this.colorList, this.child});

  @override
  _ColorPickerState createState() => _ColorPickerState(currentColor, initColorIndex, onChanged, onDone, colorList, child);
}

class _ColorPickerState extends State<ColorPicker> {

  Widget child;
  Color initialColor;
  int initColorIndex;
  int currentColorIndex;
  Color currentColor;
  Color initialColorS;
  int initColorIndexS;
  int currentColorIndexS;
  Color currentColorS;
  List<Color> colorList;
  //List<Color> colorList;
  Function(Color color, int index) onChanged;
  Function(Color color, int index) onDone;
  _ColorPickerState(this.currentColor, this.initColorIndex, this.onChanged, this.onDone, this.colorList, this.child) {
    currentColor ??= Colors.deepOrangeAccent;
    initialColor = currentColor;
    colorList ??= List.of(Colors.primaries, growable: true);
    initColorIndex ??= colorList.length-1;
    currentColorIndex = initColorIndex;
    child ??= AnimatedContainer(
      duration: Duration(seconds: 1),
      constraints: BoxConstraints(
        minWidth: 48,
        minHeight: 48,
        maxHeight: 48,
        maxWidth: 48
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentColor
      ),
    );

    child = CircleAvatar(backgroundColor: currentColor,);

    visible = List.generate(colorList.length, (index) => 0);
  }

  List<Widget> colorAvatars;
  List<double> visible;

  @override
  void initState() {
    colorAvatars = colorsCircles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    logcat('--BUILDING--');
    return GestureDetector(
      onTap: () {
        show();
      },
      child: CircleAvatar(
        backgroundColor: currentColor,
      )
    );
  }
  void show() {
    showDialog(context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(child: Text(L.string('choose_color'))),
          titlePadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.only(top: 8, bottom: 0, left: 4, right: 4),
          children: [
            Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: buildColors(),
              ),
            ),
            Divider(),
            ButtonBar(
              buttonHeight: 16,
              children: [
                FlatButton(
                  child: Text('Cancel', style: TextStyle(color: appliedTheme.accentColor),),
                  onPressed: () {
                    setState(() {
                      currentColor = initialColor;
                      currentColorIndex = initColorIndex;
                      visible.forEach((visibility) {
                        visibility = 0;
                      });
                      //visible.last = 255;
                    });
                    Navigator.of(context).pop();
                  } ,
                ),
                FlatButton(
                  child: Text('Done', style: TextStyle(color: appliedTheme.accentColor)),
                  onPressed: () {
                    /*if(onDone != null)*/ onDone(currentColor, currentColorIndex);
                    initialColor = currentColor;
                    initColorIndex = currentColorIndex;
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        );
      }
    );
  }

  List<Widget> buildColors() {
    List<Widget> widgetList = [];
    for(int i = 0; i < colorList.length; i++) {
      setCheck();
      logcat('initColorIndex: $initColorIndex');
      visible[initColorIndex] = 1;
      widgetList.add(GestureDetector(
        onTap: () {
          if(onChanged != null) onChanged(colorList[i], i);
          setState(() {
            currentColor = colorList[i];
            currentColorIndex = i;
            colorAvatars = colorsCircles();
            setCheck();
            visible[i] = 1.0;
          });
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: 32,
            minWidth: 32
          ),
          decoration: BoxDecoration(
            color: colorList[i],
            shape: BoxShape.circle
          ),
          child: Icon(
            Icons.check,
            color: ThemeData.estimateBrightnessForColor(colorList[i]) == Brightness.dark ? Colors.white.withOpacity(visible[i]) : Colors.black.withOpacity(visible[i]),
          ),
        )
      ));
    }
    return widgetList;
  }

  List<Widget> colorsCircles() {
    List<Widget> list =[];
    int i = 0;
    colorList.forEach((color) {
      list.add(CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: currentColorIndex == i ?  Icon(Icons.check, color: Colors.black.withOpacity(1)) :
          Icon(Icons.check, color: Colors.black.withOpacity(0)),
      ));
      i++;
    });
    return list;
  }

  void setCheck() {
    for(int i = 0; i < colorList.length; i++) {
        visible[i] = 0;
    }
  }
}

class Bubble extends StatelessWidget {

  String message;
  Widget child;
  bool isShown;
  Bubble(this.message, this.child);

  void init() {

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4)
          ),
          color: Colors.white,
          child: Text('text'),
        )
      ],
    );
  }
}

class FormulaItemContainer extends StatefulWidget {
  Item item;
  bool isCustom;
  FormulaItemContainer({@required this.item, @required this.isCustom});
  @override
  _FormulaItemContainer createState() => _FormulaItemContainer(item: item, isCustom: isCustom);
}

class _FormulaItemContainer extends State<FormulaItemContainer> {
  Item item;
  bool isCustom;
  _FormulaItemContainer({this.item, this.isCustom});

  List<Item> allItems;

  @override
  Widget build(BuildContext context) {
    allItems = [item];
    if(item.subItems != null) {
      allItems.addAll(item.subItems);
    }
    List<Widget> widgets = [];

    allItems.forEach((item) {
      widgets.add(buildFormulaContainer(item));
    });
    return Container(
      color: appliedTheme.cardColor,
      child: ListView(
        children: widgets,
      ),
    );
  }

  Widget buildFormulaContainer(Item item) {
    Widget getTitleWidget(Item item) {
      if(item.title == null && item.subtitle != null) {
        return Container(
          margin: EdgeInsets.only(top: 32),
            child: Text(item.subtitle, style: TextStyle(decoration: TextDecoration.underline, fontSize: 16))
        );
      } else
      if(item.title != null && item.subtitle == null) {
        return Container(
            margin: EdgeInsets.only(top: 16),
            child: Text(item.title, style: TextStyle(decoration: TextDecoration.underline, fontSize: 22, fontWeight: FontWeight.w700))
        );
      } else
      if(item.title != null && item.subtitle != null) {
        return Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(item.title, style: TextStyle(decoration: TextDecoration.underline, fontSize: 22, fontWeight: FontWeight.w700))
            ),

            Text(item.subtitle, style: TextStyle(decoration: TextDecoration.underline, fontSize: 16))
          ],
        );
      } else {
        return Padding(padding: EdgeInsets.only(bottom: 16),);
      }
    }

    Widget getDivider(Item item) {
      if(item == allItems.first) {
        return Container();
      } else {
        if(item.title != null) {
          return Divider(thickness: 1, height: 40, indent: 16, endIndent: 16);
        } else
        if(item.subtitle != null) {
          return Container();
        } else {
          return Container();
        }
      }
    }

    return Container(
      child: Column(
        children: [
          getDivider(item),
          getTitleWidget(item),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            constraints: BoxConstraints(
                minWidth: double.infinity
            ),
            decoration: BoxDecoration(
                color: Themes.getFormulaColor(),
                borderRadius: BorderRadius.circular(16)
            ),
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.result == '?' ? [
                  DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 16),
                      child: CaTeX(item.formula.toCaTeX() + '=' '?')
                  ),
                ] : [
                  DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 16),
                      child: CaTeX(item.formula.toCaTeX() + '=')
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Center(child: Text(item.result, style: TextStyle(fontSize: 20),)),
                ],
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 32
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                  hint: Text(L.string('changeTo')),
                  value: item.selectedVar,
                  //items: varList,
                  items: item.varList,
                  onChanged: (value) {
                    bool hasMultiple = item.formula.containsMultiple();
                    setState(() {
                      if(!hasMultiple) {
                        item.formula.changeTo(value);
                        item.selectedVar = value;
                      } else {
                        final snackBar = SnackBar(
                          content: Text(L.string('hasMultiple')),
                          duration: Duration(seconds: 4),
                          elevation: 8,
                          //behavior: SnackBarBehavior.floating,
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                ),
                RaisedButton(
                    color: appliedTheme.accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Text(L.string('calc'), style: TextStyle(color: ThemeData.estimateBrightnessForColor(appliedTheme.accentColor) == Brightness.dark ? Colors.white : Colors.black),),
                    onPressed:  () {
                      Map<String, double> values = {};
                      int i = 0;
                      logcat('OnPressed calc: getValues');
                      logcat('controllerList info:');
                      logcat('   length: ${item.controllerList.length}');
                      item.formula.variables.forEach((variable) {
                        double value;
                        Unit currentUnit = Units.getUnitFromString(item.units[i]);
                        if(item.controllerList[i].text == '') {
                          value = 0.0;
                          logcat('value for variable(i: $i): $variable = 0');
                        } else {
                          value = double.parse(item.controllerList[i].text);
                          logcat('value for variable: $variable = $value');
                        }
                        if(item.units[i] != currentUnit.main && value != 0 && variable != item.formula.result) {
                          value = currentUnit.getValueOf(item.units[i], value, resultUnit: currentUnit.main);
                        }
                        values[variable] = value;
                        i++;
                      });

                      String resultUnitString = item.units[item.formula.variables.indexOf(item.formula.result)];
                      Unit resultUnit = Units.getUnitFromString(resultUnitString);
                      double result = double.parse(item.formula.calc(values));
                      setState(() {
                        item.result = resultUnitString == resultUnit.main ? result.toString() : resultUnit.getValueOf(resultUnit.main, result, resultUnit: resultUnitString).toString();
                      });

                      int controllerIndex = 0;
                      for(int i = 0; i < item.formula.variables.length; i++) {
                        if(item.formula.variables[i] == item.formula.result) {
                          controllerIndex = i;
                          break;
                        }
                      }

                      item.controllerList[controllerIndex].text = item.result;
                    }
                ),
              ],
            ),
          ),
          getLegend(item)
        ],
      ),
    );
  }

  Widget getLegend(Item item) {
    List<Widget> widgets = [];
    int i = 0;
    for(int i = 0; i < item.formula.variables.length; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(top: 4, bottom: 12, right: 4, left: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 15,child: Center(child: CaTeX(Formula.toCaTeXstatic([item.formula.variables[i]])))),
            Expanded(flex: 120,child: Text(' = ' + item.meanings[i])),
            Expanded(
              flex: 90,
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: 28
                ),
                child: TextField(
                  controller: item.controllerList[i],
                  //textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      labelText: L.string('value'),
                      //border: OutlineInputBorder(
                      //    borderRadius: BorderRadius.circular(4)
                      //)
                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
            ),
            Expanded(
              flex: 50,
              child: DropdownButton(
                  items: Units.getUnitFromString(item.units[i]).getDropdownList(),
                  underline: Container(),
                  isDense: true,
                  iconEnabledColor: appliedTheme.accentColor,
                  value: item.units[i],
                  onChanged: (value) {
                    setState(() {
                      item.units[i] = value;
                    });
                  }
              ),
            ),
          ],
        ),
      ));
    }

    return Container(
      child: Column(
        children: widgets,
      ),
    );
  }
}



class FormulaExpansionListOld extends StatefulWidget {
  List<Item> data;
  bool isCustom;
  FormulaExpansionListOld({@required this.data, @required this.isCustom});

  @override
  _FormulaExpansionListOldState createState() => _FormulaExpansionListOldState(data: data, isCustom: isCustom);
}

class _FormulaExpansionListOldState extends State<FormulaExpansionListOld> {
  List<Item> data;
  bool isCustom;
  _FormulaExpansionListOldState({this.data, this.isCustom});

  /*
  @override
  void initState() {
    logcat('--INIT STATE--');
    if(data.first.controllerList.length < 1) {
      data.forEach((item) {
        item.formula.variables.forEach((variable) {
          item.controllerList.add(TextEditingController());
        });
        if(item.subItems != null) {
          item.subItems.forEach((subItem) {
            subItem.formula.variables.forEach((variable) {
              subItem.controllerList.add(TextEditingController());
            });
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    logcat('--DISPOSE--');
    data.forEach((item) {
      item.controllerList.forEach((controller) {
        controller.dispose();
      });
      item.controllerList.clear();
      if(item.subItems != null) {
        item.subItems.forEach((subItem) {
          subItem.controllerList.forEach((controller) {
            controller.dispose();
          });
          subItem.controllerList.clear();
        });
      }
    });
    super.dispose();
  }

   */

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 8),
      child: ExpansionPanelList.radio(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              data[index].isExpanded = !isExpanded;
            });
          },
          children: data.map<ExpansionPanelRadio>((Item item) {
            //return _getExpansionPanel(item: item);
            return _makeFormulaExpansionPanel(item);
          }).toList()
      ),
    );

  }

  _makeFormulaExpansionPanel(Item item) {
    return ExpansionPanelRadio(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return isCustom ? ListTile(
            title: Text(item.name),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFormula(isEdit: true, item: item,)));
              },
            ),
          ) : ListTile(
            title: Text(item.name),
          );
        },
        body: Column(
          children: _makeExpansionPanelBody(item),
        ),
        value: item.name
      //isExpanded: item.isExpanded
    );
  }
  List<Widget> _makeExpansionPanelBody(Item item) {
    List<Item> allItems = [item];
    List<Widget> allWidgets = [];

    if(item.subItems != null) {
      allItems.addAll(item.subItems);
    }

    Widget getTitleWidget(Item item) {
      if(item.title == null && item.subtitle != null) {
        return Text(item.subtitle, style: TextStyle(decoration: TextDecoration.underline, fontSize: 16));
      } else
      if(item.title != null && item.subtitle == null) {
        return Container(
          margin: EdgeInsets.only(bottom: 8),
            child: Text(item.title, style: TextStyle(decoration: TextDecoration.underline, fontSize: 22, fontWeight: FontWeight.w700))
        );
      } else
      if(item.title != null && item.subtitle != null) {
        return Column(
          children: [
            Text(item.title, style: TextStyle(decoration: TextDecoration.underline, fontSize: 22, fontWeight: FontWeight.w700)),

            Container(
              margin: EdgeInsets.only(top: 16),
                child: Text(item.subtitle, style: TextStyle(decoration: TextDecoration.underline, fontSize: 16))
            )
          ],
        );
      } else {
        return Container();
      }
    }

    Widget getDivider(Item item) {
      if(item == allItems.first) {
        return Container();
      } else {
        if(item.title != null) {
          return Divider(thickness: 2, height: 8, indent: 16, endIndent: 16);
        } else
        if(item.subtitle != null) {
          return Container();
        } else {
          return Container();
        }
      }
    }

    allItems.forEach((item) {
      String title = item.title == null ? item.subtitle : item.title;
      allWidgets.add(Container(
          margin: EdgeInsets.only(bottom: 8, top: 8, left: 4, right: 4),
          child: Column(
              children: [
                getDivider(item),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: getTitleWidget(item)
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(bottom: 4),
                  child: Column(
                      children: getLegend(item)
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(left: 16, right: 16),
                  constraints: BoxConstraints(
                    minWidth: double.infinity
                  ),
                  decoration: BoxDecoration(
                    color: Themes.getFormulaColor(),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.result == '?' ? [
                        DefaultTextStyle.merge(
                            style: TextStyle(fontSize: 16),
                            child: CaTeX(item.formula.toCaTeX() + '=' '?')
                        ),
                      ] : [
                        DefaultTextStyle.merge(
                          style: TextStyle(fontSize: 16),
                          child: CaTeX(item.formula.toCaTeX() + '=')
                        ),
                        Padding(padding: EdgeInsets.only(top: 4)),
                        Center(child: Text(item.result, style: TextStyle(fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          DropdownButton(
                            hint: Text(L.string('changeTo')),
                            value: item.selectedVar,
                            //items: varList,
                            items: item.varList,
                            onChanged: (value) {
                              bool hasMultiple = item.formula.containsMultiple();
                              /*
                              int count = 0;
                              item.formula.values.forEach((val) {
                                if(val.contains('^')) {
                                  if(val.replaceRange(val.indexOf('^'), val.length, '') == value)
                                    count++;
                                } else {
                                  if(val == value) {
                                    count++;
                                  }
                                }
                              });
                              hasMultiple = count > 1 ? true : false;
                               */
                              setState(() {
                                if(!hasMultiple) {
                                  item.formula.changeTo(value);
                                  item.selectedVar = value;
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(L.string('hasMultiple')),
                                    duration: Duration(seconds: 4),
                                    elevation: 8,
                                    //behavior: SnackBarBehavior.floating,
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxHeight: 32
                        ),
                        child: RaisedButton(
                            color: appliedTheme.accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Text(L.string('calc'), style: TextStyle(color: ThemeData.estimateBrightnessForColor(appliedTheme.accentColor) == Brightness.dark ? Colors.white : Colors.black),),
                            onPressed:  () {
                              Map<String, double> values = {};
                              int i = 0;
                              logcat('OnPressed calc: getValues');
                              logcat('controllerList info:');
                              logcat('   length: ${item.controllerList.length}');
                              item.formula.variables.forEach((variable) {
                                double value;
                                if(item.controllerList[i].text == '') {
                                  value = 0.0;
                                  logcat('value for variable(i: $i): $variable = 0');
                                } else {
                                  value = double.parse(item.controllerList[i].text);
                                  logcat('value for variable: $variable = $value');
                                }
                                values[variable] = value;
                                i++;
                              });

                              setState(() {
                                item.result = item.formula.calc(values);
                              });

                              int controllerIndex = 0;
                              for(int i = 0; i < item.formula.variables.length; i++) {
                                if(item.formula.variables[i] == item.formula.result) {
                                  controllerIndex = i;
                                  break;
                                }
                              }

                              item.controllerList[controllerIndex].text = item.result;
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          )
      ),);

    });
    return allWidgets;
  }

  List<Widget> getLegend(Item item) {
    List<Widget> widgetList = [];
    item.meanings ??= List.generate(item.formula.variables.length, (index) => 'null');
    //logcat('getLegend for item: ${item.formula.parsedRaw}');
    logcat('Variables: ${item.formula.variables}');
    for(int i = 0; i < item.formula.variables.length; i++) {
      if(item.meanings[i] != '') {
        var _focusNode = FocusNode();
        /*
        var _controller = TextEditingController();

        if(item.controllerList.length < item.formula.variables.length) {
          item.controllerList.add(_controller);
          logcat('controllerList length: ${item.controllerList.length}');
        }
         */
        if(item.units != null && item.units.length == item.formula.variables.length) {
          widgetList.add(Container(
            margin: EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(
                maxHeight: 30
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CaTeX(Formula.toCaTeXstatic([item.formula.variables[i]])),
                      Expanded(child: item.meanings[i] == 'null' ? Text(' ='):Text(' = ' + item.meanings[i])),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: item.controllerList[i],
                          focusNode: _focusNode,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: L.string('value'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          onTap: () {
                            if (_focusNode.hasFocus) {
                              setState(() {
                                _focusNode.previousFocus();
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                          child: item.units[i].contains('^') ? Row(
                            children: [
                              Text(item.units[i].split('^')[0]),
                              CaTeX('.^'+item.units[i].split('^')[1])
                            ],
                          ) : Text(item.units[i])
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
        } else {
          widgetList.add(Container(
            margin: EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(
                maxHeight: 30
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CaTeX(Formula.toCaTeXstatic([item.formula.variables[i]])),
                      Expanded(child: item.meanings[i] == 'null' ? Text(' ='):Text(' = ' + item.meanings[i])),
                    ],
                  ),
                ),
                Expanded(child: TextField(
                  controller: item.controllerList[i],
                  focusNode: _focusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: L.string('value'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  onTap: () {
                    if (_focusNode.hasFocus) {
                      setState(() {
                        _focusNode.previousFocus();
                      });
                    }
                  },
                )
                )
              ],
            ),
          ));
        }

      }
    }
    return widgetList;
  }
}
