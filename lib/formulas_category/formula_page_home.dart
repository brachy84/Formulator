
import 'package:all_the_formulars/core/formula/formula2.dart';
import 'package:all_the_formulars/core/system/storage.dart';
import 'package:all_the_formulars/core/utils.dart';
import 'package:all_the_formulars/core/widgets.dart';
import 'package:all_the_formulars/formulas_category/formula_page.dart';
import 'package:all_the_formulars/formulas_category/industrial_formulas.dart';
import 'package:all_the_formulars/formulas_category/math_formulas.dart';
import 'package:all_the_formulars/formulas_category/physik_formulas.dart';
import 'package:all_the_formulars/main.dart';
import 'package:catex/catex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';


class Item {

  Formula formula;
  String name;
  String title;
  String subtitle;
  bool isExpanded;
  List<DropdownMenuItem> varList;
  List<String> meanings = [];
  List<String> units = [];
  Map<String, double> values = {};
  List<Item> subItems = [];
  int controllerListIndex;
  List<TextEditingController> controllerList = [];
  AnimationController animationController;
  bool animationFlag;
  String result = '?';
  int id;
  static int customCount = 0;

  var selectedVar = null;

  Item({@required this.formula,
    this.name,
    this.isExpanded = false,
    this.meanings,
    this.units,
    this.subItems,
    this.title,
    this.subtitle,
    this.id}) {
    animationFlag = false;

    units ??= List.generate(formula.variables.length, (index) => 'm');
    varList = formula.variables.map((String value) {
      logcat('--DEBUG-- Item name: $name | Variable: $value');
      return DropdownMenuItem<String>(
          value: value, child: CaTeX(formula.toCaTeX(value: [value])));
    }).toList();
    if(name != null) {
      addToArchive(name, this);
    }
  }

  void updateValues() {}

  static addToArchive(String name, Item item) {
    archive.addAll({name : item});
  }
  static Map<String, Item> archive = {};


  static int listCount = 0;

  static List<String> _widgetIds = [];
  static List<String> get widgetIds => _widgetIds;

  static List<Item> _itemData = [];
  static List<Item> get itemData => _itemData;
  //static set itemData(List<Item> data2) => _itemData = data2;

  static void addCustomItem(String name, String title, String formula, JsonSetup json) {
    if(widgetIds.contains(name)) {
      Item.archive[name].subItems ??= [];
      Item.archive[name].subItems.add(Item(formula: Formula(formula), title: title, id: customCount));
    } else {
      widgetIds.add(name);
      _itemData.add(Item(formula: Formula(formula), name: name, title: title, id: customCount));
    }
    disposeController(_itemData);
    initController(_itemData);
    //TODO: Check functionality
    //customItemList.add([name, title, formula]);
    json.writeToFile(listCount.toString(), {'name': name, 'title' : title, 'formula' : formula});
    logcat('Created new Item: Formula: $formula | id: $customCount');
    customCount++;
  }

  static Future<void> initCustomItems() async {
    await jsonFile.initJson();
    List<dynamic> content = jsonFile.fileContent;
    logcat('Read content: $content');
    if(jsonFile.fileExists) {
      content.forEach((value) {
        String name = value['name'];
        String title = value['title'];
        String formula = value['formula'];
        if(widgetIds.contains(name)) {
          Item.archive[name].subItems ??= [];
          Item.archive[name].subItems.add(Item(formula: Formula(formula), title: title, id: customCount));
        } else {
          widgetIds.add(name);
          _itemData.add(Item(formula: Formula(formula), name: name, title: title, id: customCount));
        }
        logcat('Created item from JSON: Formula: $formula | id: $customCount');
        customCount++;
      });
    }
  }

  @override
  String toString() => formula.parsedRaw;

  @override
  bool operator ==(Object other) => other is Item && other.formula.parsedRaw == formula.parsedRaw;

  @override
  int get hashCode => formula.parsedRaw.hashCode;
}

class FormulaHome {
   static Widget getFormulaHome(BuildContext context) {
     return ListView(
       children: [
         _getDefaultCard(context,
            color: Colors.red[700],
            title: L.string('math'),
            subtitle: L.string('mathSubtitle'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormulaCategoryBase(categoryName: L.string('math'), subCategories: [MathFormulas.surfaceSubCategory, MathFormulas.bodySubCategory, MathFormulas.pythagorasSubCategory],)));
            }
         ),
         _getDefaultCard(context,
           color: Colors.blue[700],
           title: L.string('physic'),
             subtitle: L.string('physicSubtitle'),
           onPressed: () {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => FormulaCategoryBase(categoryName: L.string('physic'), subCategories: [PhysicFormulas.movementSubCategory, PhysicFormulas.forceSubCategory],)));
           }
         ),
         _getDefaultCard(context,
             color: Colors.grey[700],
             title: L.string('industrial'),
             subtitle: L.string('industSubtitle'),
             onPressed: () {
               Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => FormulaCategoryBase(categoryName: L.string('industrial'), subCategories: [IndustrialFormulas.placeholderSubCategory],)));
             }
         ),
         Hero(
           tag: 'customFormula',
           child: _getDefaultCard(context,
               color: Colors.green[700],
               title: L.string('myFormulas'),
               subtitle: L.string('customSubtitle'),
               onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomFormula()));
               }
           ),
         ),
       ],
     );
   }
}

Widget _getDefaultCard(BuildContext context, {Color color = Colors.white, String title = '-', String subtitle = '-', VoidCallback onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 10,
      color: color,
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: TextStyle(fontSize: 24, color: Colors.white),),
            subtitle: Text(subtitle, style: TextStyle(color: Colors.white),),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    ),
  );
}

class CustomFormula extends StatefulWidget {
  @override
  _CustomFormulaState createState() => _CustomFormulaState();
}

class _CustomFormulaState extends State<CustomFormula> {

  @override
  void initState() {
    logcat('--INIT STATE--');
    if(Item.itemData.length > 0) {
      disposeController(Item.itemData);
      initController(Item.itemData);
    }
    super.initState();
  }

  @override
  void dispose() {
    logcat('--DISPOSE--');
    if(Item.itemData.length > 0) {

    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logcat('--BUILD--');
    if(Item.itemData.length > 0 && Item.itemData.first.controllerList.length < 1) {
      initController(Item.itemData);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Formulas'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'customFormula',
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              //decoration: BoxDecoration(
              color: appliedTheme.canvasColor,
              //borderRadius: BorderRadius.circular(16)
              margin: EdgeInsets.all(12),
              child: Builder(
                builder: (BuildContext context) => ListView(children: [
                  FormulaExpansionListOld(
                    data: Item.itemData,
                    isCustom: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appliedTheme.accentColor
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      //color: appliedTheme.accentColor,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFormula(isEdit: false,)));
                        });
                      },
                    ),
                  )
                ]),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.home),
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}

class CreateFormula extends StatefulWidget {

  bool isEdit;
  Item item;

  CreateFormula({this.item, @required this.isEdit});

  @override
  _CreateFormulaState createState() => _CreateFormulaState(item: item, isEdit: isEdit);
}

class _CreateFormulaState extends State<CreateFormula> {

  bool firstTime = true;
  int tutorialOrder = 0;
  bool isEdit;
  bool isInitialized = false;
  Item item;
  _CreateFormulaState({this.item, this.isEdit});

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerFormula = TextEditingController();
  final FocusNode _focusFormula = FocusNode();

  String errorMsg = '';
  Color errorColor = Colors.grey.withOpacity(0.5);
  double saveButtonOpacity = 0.2;
  Formula formula = Formula('a=b');

  void adjustIds(int removedId) {
    Item.itemData.forEach((item) {
      if(item.id > removedId) {
        item.id--;
      }
    });
    Item.customCount--;
  }

  void checkFirstTime() async {
    firstTime = await SaveData.readData('FIRST_CREATE_FORMULA');
    firstTime ??= true;
    if(firstTime) {
      showTutorialDialog(context, L.string('tutorialDialogTitle'), L.string('tutorialDialog'));
      tutorialOrder++;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerFormula.dispose();
    _controllerName.dispose();
    _controllerTitle.dispose();
    _focusFormula.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isEdit && !isInitialized) {
      _controllerName.text = item.name;
      _controllerTitle.text = item.title;
      _controllerFormula.text = item.formula.raw;
      formula = item.formula;
      isInitialized = true;
    }

    if(tutorialOrder == 0) checkFirstTime();

    return Scaffold(
        appBar: isEdit ? AppBar(
          title: Text(L.string('createFormula')),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Delete Formula'),
                      children: [
                        Center(child: Text('The Formula will be forever gone.')),
                        ButtonBar(
                          children: [
                            FlatButton(
                              child: Text(L.string('cancel')),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('delete'),
                              onPressed: () {
                                jsonFile.deleteEntry(item);
                                Item.itemData.removeAt(item.id);
                                adjustIds(item.id);
                                Navigator.popUntil(context, (route) => route.isFirst);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomFormula()));
                              },
                            )
                          ],
                        )
                      ],
                    );
                  }
                );
              },
            )
          ],
        ) : AppBar(
          title: Text(L.string('createFormula')),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                SaveData.saveData('FIRST_CREATE_FORMULA', true);
                tutorialOrder = 0;
                checkFirstTime();
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Builder( builder: (context) =>
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () => showTutorialDialog(context, L.string('nameInfoTitle'), L.string('nameInfo')),
                        ),
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)
                        )
                    ),
                    controller: _controllerName,
                    onTap: () {
                      if(firstTime && tutorialOrder == 1) {
                        showTutorialDialog(context, L.string('tutorialDialogTitle'), L.string('tutorialName'));
                        tutorialOrder++;
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () => showTitleInfoDialog(context),
                        ),
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)
                        )
                    ),
                    controller: _controllerTitle,
                    onTap: () {
                      if(firstTime && tutorialOrder == 2) {
                        showTutorialDialog(context, L.string('tutorialDialogTitle'), L.string('tutorialTitle'));
                        tutorialOrder++;
                        if(_controllerName.text == '') {
                          _controllerName.text = 'TutorialName';
                        }
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.info_outline, color: Colors.lightBlue),
                          onPressed: () => showFormattingDialog(context),
                        ),
                        labelText: 'Formula',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)
                        )
                    ),
                    style: TextStyle(letterSpacing: 4),
                    controller: _controllerFormula,
                    focusNode: _focusFormula,
                    onChanged: (value) {
                      setState(() {
                        saveButtonOpacity = 0.2;
                      });
                    },
                    onTap: () {
                      if(firstTime && tutorialOrder == 3) {
                        showTutorialDialog(context, L.string('tutorialDialogTitle'), L.string('tutorialFormula'));
                        tutorialOrder++;
                        if(_controllerTitle.text == '') {
                          _controllerTitle.text = 'TutorialTitle';
                        }
                      }
                      if(_controllerFormula.text == '') {
                        _controllerFormula.value = TextEditingValue(text: ' ', selection: TextSelection.collapsed(offset: 0));
                      }
                    },
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 8,
                  runSpacing: 0,
                  children: [
                    _getButton(':{}/{}', name: L.string('divide')),
                    _getButton('√{}', name: L.string('root')),
                    _getButton('sin[]', name: 'sin()', posFromStart: 4),
                    _getButton('cos[]', name: 'cos()', posFromStart: 4),
                    _getButton('tan[]', name: 'tan()', posFromStart: 4),
                    _getOperatorButton('+'),
                    _getOperatorButton('-'),
                    _getOperatorButton('×'),
                    _getOperatorButton('=')
                  ],
                ),
                Divider(),
                Text(L.string('errorMsg')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                        child: Container(
                            margin: EdgeInsets.all(8),
                            child: Text(errorMsg, maxLines: 3, softWrap: true,),
                          constraints: BoxConstraints(
                            minHeight: 40
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: errorColor
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        color: Colors.green,
                        child: Text(L.string('verify')),
                        onPressed: () {
                          if(firstTime && tutorialOrder == 4) {
                            showTutorialDialog(context, L.string('tutorialDialogTitle'), L.string('tutorialVerify'));
                            tutorialOrder++;
                            if(_controllerFormula.text == '' || _controllerFormula.text == ' ') {
                              _controllerFormula.text = 'F = m * c^2';
                            }
                          }
                          Map<String, int> validCheck = isValid(_controllerFormula.text);
                          setState(() {
                            errorMsg = validCheck.keys.first;
                            logcat('Valid state: ${validCheck.values.first}');
                            if(validCheck.values.first == 2) {
                              errorColor = Colors.green.withOpacity(0.5);
                              saveButtonOpacity = 1.0;
                              //_controllerFormula.value(TextEditingValue())
                              formula = Formula(_controllerFormula.text);
                            } else if(validCheck.values.first == 1) {
                              errorColor = Colors.orange.withOpacity(0.5);
                              saveButtonOpacity = 1.0;
                              formula = Formula(_controllerFormula.text);
                            } else {
                              errorColor = Colors.red.withOpacity(0.5);
                              saveButtonOpacity = 0.2;
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
                Container(
                    child: Text(L.string('preview')),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4, right: 4, bottom: 4, top: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(fontSize: 24),
                        child: CaTeX(formula.toCaTeX())
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 48
                        ),
                        margin: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: RaisedButton(
                          child: Text(L.string('cancel'), style: TextStyle(fontSize: 20),),
                          color: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: 48
                        ),
                        margin: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: RaisedButton(
                          child: Text(L.string('save'), style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(saveButtonOpacity)),),
                          color: Colors.green[800].withOpacity(saveButtonOpacity),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          onPressed: () async {
                            if(saveButtonOpacity == 0.2) {
                              final snackBar = SnackBar(
                                content: Text(L.string('notValid')),
                                duration: Duration(seconds: 3),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            } else if(_controllerName.text == '') {
                              final snackBar = SnackBar(
                                content: Text(L.string('emptyName')),
                                duration: Duration(seconds: 3),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            } else {
                              if(isEdit) {
                                jsonFile.deleteEntry(item);
                                //await disposeController([item]);
                                item.name = _controllerName.text;
                                item.title = _controllerTitle.text;
                                item.formula = Formula(_controllerFormula.text);
                                jsonFile.writeToFile(Item.listCount.toString(), {'name': item.name, 'title' : item.title, 'formula' : item.formula.raw});
                                //await initController([item]);
                              } else {
                                String name = _controllerName.text;

                                Item.addCustomItem(name, _controllerTitle.text, _controllerFormula.text, jsonFile);

                                if(firstTime) SaveData.saveData('FIRST_CREATE_FORMULA', false);
                              }
                              disposeController(Item.itemData);
                              logcat('Saving done. Now returning');
                              Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomFormula()));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _getButton(String output, {String name, int posFromStart = 2, int posFromEnd = 1}) {
    name ??= output;
    return Container(
      //constraints: BoxConstraints(maxWidth: 96),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        child: Text(name, style: TextStyle(color: Colors.black),),
        onPressed: () {
          _focusFormula.requestFocus();
          final String text = _controllerFormula.text;
          final TextSelection selection = _controllerFormula.selection;
          //_controllerFormula.text += output;
          if(text != '') {
            String newText = text.substring(0, selection.end) + output + text.substring(selection.end);
            TextSelection newSelection = TextSelection.collapsed(offset: selection.end+posFromStart);
            _controllerFormula.value = TextEditingValue(text: newText, selection: newSelection);
          } else {
            _controllerFormula.value = TextEditingValue(text: _controllerFormula.text += output, selection: TextSelection.collapsed(offset: posFromStart));
          }
          setState(() {
            saveButtonOpacity = 0.2;
          });
        },
      ),
    );
  }

  Widget _getOperatorButton(String output, {String name}) {
    name ??= output;
    return Container(
      constraints: BoxConstraints(maxWidth: 64),
      child: Tooltip(
        message: output,
        child: RaisedButton(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          child: Text(name, style: TextStyle(color: Colors.black),),
          onPressed: () {
            final String text = _controllerFormula.text;
            final TextSelection selection = _controllerFormula.selection;

            _focusFormula.requestFocus();
            logcat('text length: ${text.length}');
            logcat('selection: ${selection.end}');
            if(text != '') {
              String newText;
              if(selection.end >= text.length) {
                newText = text + output;
              } else {
                newText = text.substring(0, selection.end) + output + text.substring(selection.end);
              }
              TextSelection newSelection = TextSelection.collapsed(offset: selection.end+output.length);
              _controllerFormula.value = TextEditingValue(text: newText, selection: newSelection);
            } else {
              _controllerFormula.value = TextEditingValue(text: _controllerFormula.text += output, selection: TextSelection.collapsed(offset: _controllerFormula.text.length));
            }
            setState(() {
              saveButtonOpacity = 0.2;
            });
          },
        ),
      ),
    );
  }

  void showTutorialDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            backgroundColor: Colors.blue[400],
            title: Center(child: Text(title, style: TextStyle(color: Colors.grey[900]),)),
            titlePadding: EdgeInsets.all(12),
            contentPadding: EdgeInsets.all(0),
            children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Text(content, style: TextStyle(fontSize: 16, color: Colors.grey[900]))
              ),
              ButtonBar(
                children: [
                  FlatButton(
                    child: Text(L.string('gotit'), style: TextStyle(fontSize: 18, color: Colors.grey[900])),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
        }
    );
  }

  void showTitleInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
                child: Text(L.string('titleInfoTitle'), maxLines: 12, softWrap: true,)),
            titlePadding: EdgeInsets.all(12),
            contentPadding: EdgeInsets.all(0),
            children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Text(
                      L.string('titleInfo'))
              ),
              ButtonBar(
                children: [
                  FlatButton(
                    child: Text(L.string('gotit')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
        }
    );
  }

  void showFormattingDialog(BuildContext context) {
    Widget _createExampleRow(String raw) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 1,child: Text(raw)),
          Center(child: Text('    =    ')),
          Flexible(flex: 1,child: CaTeX(Formula('a=b').toCaTeX(value: raw.split(' '))))
        ],
      );
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(child: Text(L.string('formatRulesTitle'), maxLines: 12, softWrap: true,)),
            titlePadding: EdgeInsets.all(12),
            contentPadding: EdgeInsets.all(0),
            children: [
              Container(
                margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Column(
                      children: [
                        Text(L.string('formatRules')),
                        Container(margin: EdgeInsets.only(top: 8),child: Text(L.string('bsp'))),
                        _createExampleRow(':{ g * h }/{ 2 }'),
                        Divider(),
                        _createExampleRow('√{ g * h }'),
                        Divider(),
                        _createExampleRow('√{ :{ g * h }/{ 2 } }'),
                        Divider(),
                        _createExampleRow('g^2'),
                        Divider(),
                        _createExampleRow('F_2 = ^3 √{ g }'),
                        Divider(),
                        _createExampleRow('X_{nice} = :{ alpha * beta }/{ ^9 √{ pi^2 * 666 } }')
                      ]
                  )
              ),
              ButtonBar(
                children: [
                  FlatButton(
                    child: Text(L.string('gotit')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
      }
    );
  }

  /// Rules:
  /// -Must have exactly one '='
  /// -Spacing does not matter
  /// -The amount of closing and opening braces should be equal
  Map<String, int> isValid(String raw) {
    if(raw == '')
      return {'Error: The Formula must not be empty' : 0};

    int curlyBrace = 0;
    int brace = 0;
    int brackets = 0;
    int equals = 0;

    for(int i = 0; i < raw.length; i++) {
      switch(raw[i]) {
        case '=': equals++; break;
        case '(': brace++; break;
        case ')': brace--; break;
        case '{': curlyBrace++; break;
        case '}': curlyBrace--; break;
        case '[': brackets++; break;
        case ']': brackets--; break;
      }
    }
    if(equals != 1)
      return {L.string('E:valid0') : 0};

    if((Formula.isCalcOperator(raw[0]) || raw[0] == '=') || (Formula.isCalcOperator(raw[raw.length-1]) || raw[raw.length-1] == '=')) {
      return {L.string('E:valid1') : 0};
    }

    if(curlyBrace != 0)
      return {L.string('E:valid2') : 0};

    if(brace != 0)
      return {L.string('E:valid3') : 0};

    if(brackets != 0)
      return {L.string('E:valid4') : 0};

    Formula formula = Formula(raw);
    if(formula.containsMultiple()) {
      logcat('is warning');
      return {L.string('W:valid0') : 1};
    }

    return {'Valid' : 2};
  }
}