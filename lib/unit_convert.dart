import 'dart:math';
import 'dart:ui';

import 'package:all_the_formulars/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main.dart';

class UnitConvertHome {

  static Widget getHero(BuildContext context, SmartUnitConvertCard widget, {Color color, Color iconColor = Colors.black}) {
    return Hero(
        tag: widget.langName,
        child: getCardTemplate(
          context,
          widget.langName,
          icon: FaIcon(widget.icon,
              color: iconColor),
          color: color,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget));
          },
        )
    );
  }

  static Widget getUnitConvertHome(BuildContext context) {
    return ListView(
      children: [
        Hero(
            tag: 'lengthSurfaceVolume',
            child: getCardTemplate(
              context,
              'lengthSurfaceVolume',
              color: Colors.red[400],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LengthSurfaceVolume()));
              },
            )),
        getHero(context, speed, color: Colors.lightGreen[400]),
        getHero(context, weights, color: Colors.lightBlue[400]),
        getHero(context, temperatures, color: Colors.yellow[400]),
        getHero(context, time, color: Colors.purple[400]),
        getHero(context, angle, color: Colors.orange[400]),
        getHero(context, pressure, color: Colors.grey[400]),
        getHero(context, data, color: Colors.teal[400]),
      ],
    );
  }


}

String getTextString(double value, {int limit = 6}) {
  double endVal = Utils.dp((value), limit);

  if (endVal >= 9223372036854.775) return L.string('E:highValue');
  return endVal.toString();
}

class SmartUnitConvertCard extends StatefulWidget {

  String langName;
  Map<List<String>, double> values; /// {[lang, symbol] : factor}
  Function(int id, String name, String value, double factor, List<TextEditingController> controller) updateText;
  IconData icon;

  List<TextEditingController> _controller = [];

  SmartUnitConvertCard({@required this.langName, @required this.values, this.updateText, this.icon}) {
    values.forEach((key, factor) {
      _controller.add(TextEditingController());
    });
  }

  @override
  _SmartUnitConvertCardState createState() => _SmartUnitConvertCardState();
}

class _SmartUnitConvertCardState extends State<SmartUnitConvertCard> {

  _SmartUnitConvertCardState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string(widget.langName)),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: widget.langName,
          child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              //decoration: BoxDecoration(
              color: appliedTheme.canvasColor,
              //borderRadius: BorderRadius.circular(16)
              margin: EdgeInsets.all(12),
              child: Builder(
                builder: (BuildContext context) => ListView(
                  children: makeTextFields(context),
                ),
              )),
        ),
      ),
    );
  }

  List<Widget> makeTextFields(BuildContext context) {
    List<Widget> widgets = [];
    int i = 0;
    widget.values.forEach((key, factor) {
      widgets.add(getTextField(i, context, L.string(key[0]), key[1], factor, widget._controller[i]));
      i++;
    });
    return widgets;
  }

  void updateTextFiels(int id, String name, String value, double factor) {
    if(widget.updateText != null)
      setState(() {widget.updateText(id, name, value, factor, widget._controller);});
    else {
      double number = factor > 0 ? double.parse(value) * factor : double.parse(value) / (factor * -1);
      if (value == ' ' || value == null) number = 0.0;

      int i = 0;
      setState(() {
        widget.values.forEach((key, factor2) {
          if(id != i) {
            widget._controller[i].text =  getTextString(factor2 > 0 ? (number / factor2) : (number * (factor2 * -1)));
          }
          i++;
        });
      });
    }
  }

  Widget getTextField(int id, BuildContext context, String locName, String shortName, double factor, TextEditingController controller, {IconData icon}) {
    icon ??= widget.icon;
    return Container(
      constraints: BoxConstraints(maxHeight: 56),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: locName,
                  labelStyle: TextStyle(fontSize: 12),
                  icon: FaIcon(icon)),
              controller: controller,
              onChanged: (value) => updateTextFiels(id, locName, value, factor),
              onTap: () => controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length),
            ),
          ),
          Flexible(flex: 1, child: Text(shortName))
        ],
      ),
    );
  }
}

class UnitConvertCard {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).accentColor,
        child: Hero(
          tag: '',
          child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              //decoration: BoxDecoration(
              color:appliedTheme.canvasColor,
              //borderRadius: BorderRadius.circular(16)
              margin: EdgeInsets.all(12),
              child: Builder(
                builder: (BuildContext context) => ListView(
                  children: [],
                ),
              )),
        ),
      ),
    );
  }

  void updateTextField(int id, String name, String value, double factor) {
    double number = double.parse(value) * factor;
    value == '' ? number = 0.0 : number = double.parse(value) * factor;
  }

  Widget getTextField(int id, BuildContext context, String locName, String shortName, double factor, TextEditingController controller) {
    return Container(
      constraints: BoxConstraints(maxHeight: 56),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: locName,
            labelStyle: TextStyle(fontSize: 12),
            icon: Icon(Icons.straighten)),
        controller: controller,
        onChanged: (value) => updateTextField(id, locName, value, factor),
        onTap: () => controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length),
      ),
    );
  }
}

Widget getCardTemplate(BuildContext context, String name, {VoidCallback onPressed, Widget icon, Color color = Colors.white}) {
  if (icon == null)
    icon = FaIcon(
      FontAwesomeIcons.shapes,
      color: Colors.black,
    );
  return Card(
    color: color,
    elevation: 5,
    margin: EdgeInsets.only(left: 12, right: 12, top: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(margin: EdgeInsets.only(left: 8), child: icon),
        Text(
          L.string(name),
          style: TextStyle(color: Colors.black),
        ),
        Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
              onPressed: onPressed),
        ),
      ],
    ),
  );
}

/// Page 1
/// Length, Surface & Volume
class LengthSurfaceVolume extends StatefulWidget {
  @override
  _LengthSurfaceVolumeState createState() => _LengthSurfaceVolumeState();
}

class _LengthSurfaceVolumeState extends State<LengthSurfaceVolume> implements UnitConvertCard {
  var _meterController = TextEditingController();
  var _kiloMController = TextEditingController();
  var _centiMController = TextEditingController();
  var _milliMController = TextEditingController();
  var _inchController = TextEditingController();
  var _mileController = TextEditingController();
  var _hektarController = TextEditingController();
  var _literController = TextEditingController();

  List<TextEditingController> controllerList = [];

  List<List<String>> locStrings = [
    [
      L.string('meter'),
      L.string('kiloM'),
      L.string('centiM'),
      L.string('milliM'),
      L.string('inch'),
      L.string('foot'),
      L.string('yard'),
      L.string('mile')
    ],
    [
      L.string('SqMeter'),
      L.string('SqKiloM'),
      L.string('SqCentiM'),
      L.string('SqMilliM'),
      L.string('SqInch'),
      L.string('SqFoot'),
      L.string('SqYard'),
      L.string('SqMile')
    ],
    [
      L.string('CuMeter'),
      L.string('CuKiloM'),
      L.string('CuCentiM'),
      L.string('CuMilliM'),
      L.string('CuInch'),
      L.string('CuFoot'),
      L.string('CuYard'),
      L.string('CuMile')
    ]
  ];

  int dim = 0;

  @override
  void initState() {
    controllerList = [
      _meterController,
      _kiloMController,
      _centiMController,
      _milliMController,
      _inchController,
      _mileController,
      _hektarController,
      _literController
    ];
    super.initState();
  }

  var selectedList = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('lengthSurfaceVolume')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'lengthSurfaceVolume',
          child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              //decoration: BoxDecoration(
              color: appliedTheme.canvasColor,
              //borderRadius: BorderRadius.circular(16)
              margin: EdgeInsets.all(12),
              child: Builder(
                builder: (BuildContext context) => ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                      child: Center(
                        child: ToggleButtons(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width / 4,
                              minHeight: 24),
                          borderColor: Color.fromARGB(255, 207, 207, 207),
                          borderWidth: 2,
                          selectedBorderColor: appliedTheme.accentColor,
                          splashColor: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: appliedTheme.brightness == Brightness.dark ? Colors.white : Colors.black,
                          fillColor: appliedTheme.accentColor.withAlpha(50),
                          children: [
                            Row(
                              children: [
                                Text(L.string('length')),
                              ],
                            ),
                            Row(
                              children: [
                                Text(L.string('surface')),
                              ],
                            ),
                            Row(
                              children: [
                                Text(L.string('volume')),
                              ],
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              dim = index;
                              for (int choosenIndex = 0;
                                  choosenIndex < selectedList.length;
                                  choosenIndex++) {
                                choosenIndex == index
                                    ? selectedList[choosenIndex] = true
                                    : selectedList[choosenIndex] = false;
                              }
                              controllerList.forEach((controller) {
                                controller.text = '';
                              });
                            });
                          },
                          isSelected: selectedList,
                        ),
                      ),
                    ),
                    getTextField(0, context, locStrings[dim][1], 'km', getPow(1000.0, dim + 1), _kiloMController, nameExp: true),
                    getTextField(1, context, locStrings[dim][0], 'm', getPow(1.0, dim + 1), _meterController, nameExp: true),
                    getTextField(2, context, locStrings[dim][2], 'cm', getPow(0.01, dim + 1), _centiMController, nameExp: true),
                    getTextField(3, context, locStrings[dim][3], 'mm', getPow(0.001, dim + 1), _milliMController, nameExp: true),
                    getTextField(4, context, locStrings[dim][4], 'inch', getPow(0.0254, dim + 1), _inchController, nameExp: true),
                    getTextField(5, context, locStrings[dim][5], 'mile', getPow(1609.34, dim + 1), _mileController, nameExp: true),
                    getTextField(6, context, L.string('hectar'), 'ha', getPow(10000, dim + 1), _hektarController, requirement: 1, iconData: FontAwesomeIcons.rulerCombined),
                    getTextField(7, context, L.string('liter'), 'l', getPow(0.1, dim + 1), _literController, requirement: 2, iconData: FontAwesomeIcons.prescriptionBottle)
                  ],
                ),
              )),
        ),
      ),
    );
  }
  // 1609.34
  // 0.000621371

  void updateTextField(int id, String name, String value, double factor) {
    double number = double.parse(value) * factor;
    value == '' ? number = 0.0 : number = double.parse(value) * factor;
    print('$factor');
    print(dim);

    setState(() {
      id == 0
          ? null
          : _kiloMController.text =
              getTextString(number * getPow(0.001, dim + 1));
      id == 1
          ? null
          : _meterController.text =
              getTextString(number * getPow(1.0, dim + 1));
      id == 2
          ? null
          : _centiMController.text =
              getTextString(number * getPow(100, dim + 1));
      id == 3
          ? null
          : _milliMController.text =
              getTextString(number * getPow(1000, dim + 1));

      id == 4
          ? null
          : _inchController.text =
              getTextString(number * getPow(39.37, dim + 1));
      id == 5
          ? null
          : _mileController.text =
              getTextString(number * getPow(0.000621371, dim + 1));

      id == 6
          ? null
          : _hektarController.text =
              getTextString(number * getPow(0.0001, dim + 1));
      id == 7
          ? null
          : _literController.text = getTextString(number * getPow(10, dim + 1));
    });
  }

  String getTextString(double value) {
    double endVal = Utils.dp((value), 6);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }

  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller,
      {int requirement = -1, bool nameExp = false, IconData iconData}) {
    Widget icon;
    bool enabled = true;
    double height = 56.0;
    Color iconColor = IconTheme.of(context).color;
    Color textColor = appliedTheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    if (iconData == null) iconData = FontAwesomeIcons.ruler;

    if (nameExp) {
      switch (dim) {
        case 0:
          iconData = FontAwesomeIcons.ruler;
          break;
        case 1:
          shortName += '²';
          iconData = FontAwesomeIcons.rulerCombined;
          break;
        case 2:
          shortName += '³';
          iconData = FontAwesomeIcons.diceD6;
          break;
        default:
          iconData = FontAwesomeIcons.ruler;
          break;
      }
    }

    if (requirement != -1 && dim == requirement) {
      enabled = true;
      height = 56.0;
      iconColor = IconTheme.of(context).color;
      textColor = appliedTheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    } else if (requirement != -1) {
      enabled = false;
      height = 0.0;
      iconColor = Theme.of(context).canvasColor;
      textColor = Color.fromARGB(0, 0, 0, 0);
    }

    icon = FaIcon(
      iconData,
      color: iconColor,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: height),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  enabled: enabled,
                  border: UnderlineInputBorder(),
                  labelText: locName,
                  labelStyle: TextStyle(fontSize: 12),
                  icon: icon),
              style: TextStyle(color: textColor),
              enabled: enabled,
              controller: controller,
              onChanged: (value) => updateTextField(id, locName, value, factor),
              onTap: () => controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length),
            ),
          ),
          Flexible(flex: 1, child: Text(shortName))
        ],
      ),
    );
  }

  double getPow(double val, int exp) {
    if (exp == 1) return val;
    return pow(val, exp);
  }
}

/// Page 2
/// Speed
var speed = SmartUnitConvertCard(
    langName: 'speed',
    values: {
      ['kmh', 'km/h'] : 1,
      ['ms', 'm/s'] : 3.6,
      ['mileh', 'mile/h'] : 1.60934,
      ['foots', 'foot/s'] : 1.09728
    },
    icon: FontAwesomeIcons.tachometerAlt
);

/// Page 3
/// Weights
var weights = SmartUnitConvertCard(
    langName: 'weight',
    values: {
      ['tonne', 't'] : 1000000,
      ['kiloG', 'kg'] : 1000,
      ['gramm', 'g'] : 1,
      ['milliG', 'mg'] : 0.001,
      ['pound', 'lb'] : 453.592,
      ['ounce', 'oz'] : 28.3495,
    },
    icon: FontAwesomeIcons.weightHanging
);

/// Page 4
/// Temperatures
var temperatures = SmartUnitConvertCard(
    langName: 'temperature',
    values: {
      ['celsius', '°C'] : 1,
      ['fahrenheit', '°F'] : 1,
      ['kelvin', 'K'] : 1
    },
    icon: FontAwesomeIcons.thermometerHalf,
    updateText: (id, locName, value, factor, controller) {
      double number = double.parse(value) * factor;
      value == '' ? number = 0.0 : number = double.parse(value) * factor;

      double celsius;
      double fahrenheit;
      double kelvin;

      if (id == 0) {
        celsius = 0;
        fahrenheit = number * 1.8 + 32;
        kelvin = number + 273.15;
      } else if (id == 1) {
        celsius = (number - 32) * 5.0 / 9.0;
        fahrenheit = 0;
        kelvin = (number + 459.67) * 5.0 / 9.0;
      } else {
        celsius = number - 273.15;
        fahrenheit = number * 1.8 - 459.67;
        kelvin = 0;
      }
      id == 0 ? null : controller[0].text = getTextString(celsius);
      id == 1 ? null : controller[1].text = getTextString(fahrenheit);
      id == 2 ? null : controller[2].text = getTextString(kelvin);
    },
 );

/// Page 5
/// Time
var time = SmartUnitConvertCard(
    langName: 'time',
    values: {
      ['year', 'a'] : 365.2422,
      ['month', 'a/12'] : 365.2422 / 12,
      ['week', '7d'] : 7,
      ['day', 'd'] : 1,
      ['hour', 'h'] : -24,
      ['minute', 'min'] : -1440,
      ['second', 's'] : -86400
    },
    icon: FontAwesomeIcons.clock
);

/// Page 6
/// Angle
var angle = SmartUnitConvertCard(
    langName: 'angle',
    values: {
      ['degree', '°'] : 1,
      ['gon', 'gon'] : 0.9,
      ['minute', 'min'] : -60,
      ['second', 's'] : -3600,
      ['radiant', 'rad'] : 1,
    },
    icon: FontAwesomeIcons.draftingCompass,
    updateText: (int id, String name, String value, double factor, List<TextEditingController> controller) {
      double toRadiant(double value) => value * (pi / 180);
      double fromRadiant(double value) => value * (180 / pi);

      double number;
      factor > 0
          ? number = double.parse(value) * factor
          : number = double.parse(value) / (factor * -1);
      if (value == ' ' || value == null) number = 0.0;

      if (id == 3) number = fromRadiant(number);
      print(number);

        id == 0 ? null : controller[0].text = getTextString(number * 1);
        id == 1 ? null : controller[1].text = getTextString(number / 0.9);
        id == 2 ? null : controller[2].text = getTextString(number * 60);
        id == 3 ? null : controller[3].text = getTextString(number * 3600);
        id == 4 ? null : controller[4].text = getTextString(toRadiant(number * 1));
    },
);

/// Page 7
/// Pressure
var pressure = SmartUnitConvertCard(
    langName: 'pressure',
    values: {
      ['bar', 'bar'] : 1,
      ['pascal', 'Pa'] : -100000,
      ['n/mm²', 'N/mm²'] : 10,
      ['n/cm²', 'N/cm²'] : -10,
      ['n/m²', 'N/m²'] : -100000,
    },
    icon: FontAwesomeIcons.compressArrowsAlt
);

/// Page 9
/// Data
var data = SmartUnitConvertCard(
    langName: 'data',
    values: {
      ['bit', 'Bit'] : -1000000,
      ['kilobit', 'Kbit'] : -1000,
      ['megabit', 'Mbit'] : 1,
      ['gigabit', 'Gbit'] : 1000,
      ['terrabit', 'Tbit'] : 1000000,
      ['petabit', 'Pbit'] : 1000000000,
      ['byte', 'b'] : -125000,
      ['kilobyte', 'Kb'] : -125,
      ['megabyte', 'Mb'] : 8,
      ['gigabyte', 'Gb'] : 8000,
      ['terrabyte', 'Tb'] : 8000000,
      ['petabyte', 'Pb'] : 8000000000,
    },
    icon: FontAwesomeIcons.weightHanging
);

/// Page 10
/// Forces
// TODO: forces

/// Page 11
/// currencies
// TODO: currencies (mit echtzeit wechselkurs)