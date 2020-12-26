import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:all_the_formulars/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'core/themes.dart';
import 'main.dart';

class UnitConvertHome {
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
        Hero(
            tag: 'speed',
            child: getCardTemplate(
              context,
              'speed',
              icon: FaIcon(FontAwesomeIcons.tachometerAlt, color: Colors.black),
              color: Colors.lightGreen[400],
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Speed()));
              },
            )),
        Hero(
            tag: 'weight',
            child: getCardTemplate(
              context,
              'weight',
              icon: FaIcon(FontAwesomeIcons.weightHanging, color: Colors.black),
              color: Colors.lightBlue[400],
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Weight()));
              },
            )),
        Hero(
            tag: 'temperatur',
            child: getCardTemplate(
              context,
              'temperatur',
              icon:
                  FaIcon(FontAwesomeIcons.thermometerHalf, color: Colors.black),
              color: Colors.yellow[400],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Temperature()));
              },
            )),
        Hero(
            tag: 'time',
            child: getCardTemplate(
              context,
              'time',
              icon: FaIcon(FontAwesomeIcons.clock, color: Colors.black),
              color: Colors.purple[300],
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Time()));
              },
            )),
        Hero(
            tag: 'angle',
            child: getCardTemplate(
              context,
              'angle',
              icon:
                  FaIcon(FontAwesomeIcons.draftingCompass, color: Colors.black),
              color: Colors.orange[400],
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Angle()));
              },
            )),
        Hero(
            tag: 'pressure',
            child: getCardTemplate(
              context,
              'pressure',
              icon: FaIcon(FontAwesomeIcons.compressArrowsAlt,
                  color: Colors.black),
              color: Colors.grey[400],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Pressure()));
              },
            )
        ),
      ],
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

  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller) {
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

Widget getCardTemplate(BuildContext context, String name,
    {VoidCallback onPressed, Widget icon, Color color = Colors.white}) {
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

class _LengthSurfaceVolumeState extends State<LengthSurfaceVolume>
    implements UnitConvertCard {
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

class Speed extends StatefulWidget {
  @override
  _SpeedState createState() => _SpeedState();
}

class _SpeedState extends State<Speed> implements UnitConvertCard {
  var _kmhController = TextEditingController();
  var _msController = TextEditingController();
  var _milehController = TextEditingController();
  var _footsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('speed')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'speed',
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
                    getTextField(0, context, L.string('kmh'), 'km/h', 10,
                        _kmhController),
                    getTextField(1, context, L.string('ms'), 'm/s', 0.36,
                        _msController),
                    getTextField(2, context, L.string('mileh'), 'mile/h',
                        0.160934, _milehController),
                    getTextField(3, context, L.string('foots'), 'foot/s',
                        0.109728, _footsController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  void updateTextField(int id, String name, String value, double factor) {
    double number = double.parse(value) * factor;
    value == '' ? number = 0.0 : number = double.parse(value) * factor;

    setState(() {
      id == 0 ? null : _kmhController.text = getTextString(number * 10);
      id == 1
          ? null
          : _msController.text = getTextString(number * 0.0277777778);
      id == 2
          ? null
          : _milehController.text = getTextString(number * 0.0621371);
      id == 3
          ? null
          : _footsController.text = getTextString(number * 0.0911344);
    });
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller,
      {int requirement = -1, IconData icon = FontAwesomeIcons.tachometerAlt}) {
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

  String getTextString(double value) {
    double endVal = Utils.dp((value), 6);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }
}

/// Page 3
/// Weights

class Weight extends StatefulWidget {
  @override
  _WeightState createState() => _WeightState();
}

class _WeightState extends State<Weight> implements UnitConvertCard {
  var _tonnController = TextEditingController();
  var _kiloGController = TextEditingController();
  var _grammGController = TextEditingController();
  var _milliGController = TextEditingController();
  var _poundController = TextEditingController();
  var _ounceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('weight')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'weight',
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
                    getTextField(0, context, L.string('tonne'), 't', 1000000,
                        _tonnController),
                    getTextField(1, context, L.string('kiloG'), 'kg', 1000,
                        _kiloGController),
                    getTextField(2, context, L.string('gramm'), 'g', 1,
                        _grammGController),
                    getTextField(3, context, L.string('milliG'), 'mg', 0.001,
                        _milliGController),
                    getTextField(4, context, L.string('pound'), 'lb', 500,
                        _poundController),
                    getTextField(5, context, L.string('ounce'), 'oz', 28.3495,
                        _ounceController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller,
      {int requirement = -1}) {
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
                  icon: FaIcon(FontAwesomeIcons.weightHanging)),
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

  @override
  void updateTextField(int id, String name, String value, double factor) {
    double number = double.parse(value) * factor;
    value == '' ? number = 0.0 : number = double.parse(value) * factor;

    setState(() {
      id == 0 ? null : _tonnController.text = getTextString(number * 0.000001);
      id == 1 ? null : _kiloGController.text = getTextString(number * 0.001);
      id == 2 ? null : _grammGController.text = getTextString(number * 1);
      id == 3 ? null : _milliGController.text = getTextString(number * 1000);
      id == 4 ? null : _poundController.text = getTextString(number * 0.002);
      id == 5
          ? null
          : _ounceController.text = getTextString(number * 0.0352739907);
    });
  }

  String getTextString(double value) {
    double endVal = Utils.dp((value), 6);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }
}

/// Page 4
/// Temperatures
class Temperature extends StatefulWidget {
  @override
  _TemperatureState createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> implements UnitConvertCard {
  var _celsiusController = TextEditingController();
  var _fahrenheitController = TextEditingController();
  var _kelvinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('temperatur')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'temperatur',
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
                    getTextField(0, context, L.string('celsius'), '°C', 1,
                        _celsiusController),
                    getTextField(1, context, L.string('fahrenheit'), '°F', 1,
                        _fahrenheitController),
                    getTextField(2, context, L.string('kelvin'), 'K', 1,
                        _kelvinController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller) {
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
                  icon: FaIcon(FontAwesomeIcons.thermometerHalf)),
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

  @override
  void updateTextField(int id, String name, String value, double factor) {
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
    setState(() {
      id == 0 ? null : _celsiusController.text = getTextString(celsius);
      id == 1 ? null : _fahrenheitController.text = getTextString(fahrenheit);
      id == 2 ? null : _kelvinController.text = getTextString(kelvin);
    });
  }

  String getTextString(double value) {
    double endVal = Utils.dp((value), 3);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }
}

/// Page 5
/// Time
class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> implements UnitConvertCard {
  var _yearController = TextEditingController();
  var _monthController = TextEditingController();
  var _weekController = TextEditingController();
  var _dayController = TextEditingController();
  var _hourController = TextEditingController();
  var _minuteController = TextEditingController();
  var _secondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('time')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'time',
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
                    getTextField(0, context, L.string('year'), 'a', 365.2422,
                        _yearController),
                    getTextField(1, context, L.string('month'), '1/12a',
                        30.43685, _monthController),
                    getTextField(2, context, L.string('week'), '7d', 7,
                        _weekController),
                    getTextField(
                        3, context, L.string('day'), 'd', 1, _dayController),
                    //0.041666666666666667
                    getTextField(4, context, L.string('hour'), 'h', -24.0,
                        _hourController),
                    getTextField(5, context, L.string('minute'), 'min',
                        -1440.0, _minuteController),
                    getTextField(6, context, L.string('second'), 's',
                        -86400.0, _secondController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller) {
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
                  icon: FaIcon(FontAwesomeIcons.clock)),
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

  @override
  void updateTextField(int id, String name, String value, double factor) {
    double number;
    factor > 0
        ? number = double.parse(value) * factor
        : number = double.parse(value) / (factor * -1);
    if (value == ' ' || value == null) number = 0.0;

    setState(() {
      //0.0027379092558307885
      id == 0
          ? null
          : _yearController.text = getTextString(number / 365.2422, limit: 4);
      //0.032854911069969457
      id == 1
          ? null
          : _monthController.text = getTextString(number / 30.43685, limit: 3);
      id == 2 ? null : _weekController.text = getTextString(number / 7);
      id == 3 ? null : _dayController.text = getTextString(number * 1);
      id == 4 ? null : _hourController.text = getTextString(number * 24);
      id == 5 ? null : _minuteController.text = getTextString(number * 1440);
      id == 6 ? null : _secondController.text = getTextString(number * 86400);
    });
  }

  String getTextString(double value, {int limit = 6}) {
    double endVal = Utils.dp((value), limit);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }
}

/// Page 6
/// Angle
class Angle extends StatefulWidget {
  @override
  _AngleState createState() => _AngleState();
}

class _AngleState extends State<Angle> implements UnitConvertCard {
  var _degreeController = TextEditingController();
  var _minuteController = TextEditingController();
  var _secondController = TextEditingController();
  var _radiantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('angle')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'angle',
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
                    getTextField(0, context, L.string('degree'), '°', 1,
                        _degreeController),
                    getTextField(1, context, L.string('minute'), 'min', -60,
                        _minuteController),
                    getTextField(2, context, L.string('second'), 's', -3600,
                        _secondController),
                    getTextField(3, context, L.string('radiant'), 'rad', 1,
                        _radiantController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller,
      {int requirement = -1}) {
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
                  icon: FaIcon(FontAwesomeIcons.draftingCompass)),
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

  @override
  void updateTextField(int id, String name, String value, double factor) {
    double number;
    factor > 0
        ? number = double.parse(value) * factor
        : number = double.parse(value) / (factor * -1);
    if (value == ' ' || value == null) number = 0.0;

    if (id == 3) number = fromRadiant(number);
    print(number);

    setState(() {
      id == 0 ? null : _degreeController.text = getTextString(number * 1);
      id == 1 ? null : _minuteController.text = getTextString(number * 60);
      id == 2 ? null : _secondController.text = getTextString(number * 3600);
      id == 3
          ? null
          : _radiantController.text = getTextString(toRadiant(number * 1));
    });
  }

  String getTextString(double value) {
    double endVal = Utils.dp((value), 6);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }

  double toRadiant(double value) {
    return value * (pi / 180);
  }

  double fromRadiant(double value) {
    return value * (180 / pi);
  }
}

/// Page 7
/// Pressure
class Pressure extends StatefulWidget {
  @override
  _PressureState createState() => _PressureState();
}

class _PressureState extends State<Pressure> {
  var _barController = TextEditingController();
  var _pascalController = TextEditingController();
  var _npermmController = TextEditingController();
  var _npercmController = TextEditingController();
  var _npermController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.string('pressure')),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appliedTheme.primaryColorLight,
        child: Hero(
          tag: 'pressure',
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
                    getTextField(0, context, L.string('bar'), 'bar', 1,
                        _barController),
                    getTextField(1, context, L.string('pascal'), 'Pa',
                        -100000, _pascalController),
                    getTextField(2, context, L.string('n/mm²'), 'N/mm²', 10,
                        _npermmController),
                    getTextField(3, context, L.string('n/cm²'), 'N/cm²', -10,
                        _npercmController),
                    getTextField(4, context, L.string('n/m²'), 'N/m²',
                        -100000, _npermController),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget getTextField(int id, BuildContext context, String locName,
      String shortName, double factor, TextEditingController controller) {
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
                  icon: FaIcon(FontAwesomeIcons.compressArrowsAlt)),
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

  @override
  void updateTextField(int id, String name, String value, double factor) {
    double number;
    factor > 0
        ? number = double.parse(value) * factor
        : number = double.parse(value) / (factor * -1);
    if (value == ' ' || value == null) number = 0.0;

    setState(() {
      id == 0 ? null : _barController.text = getTextString(number * 1);
      id == 1 ? null : _pascalController.text = getTextString(number * 100000);
      id == 2 ? null : _npermmController.text = getTextString(number / 10);
      id == 3 ? null : _npercmController.text = getTextString(number * 10);
      id == 4 ? null : _npermController.text = getTextString(number * 100000);
    });
  }

  String getTextString(double value, {int limit = 6}) {
    double endVal = Utils.dp((value), limit);

    if (endVal >= 9223372036854.775) return L.string('E:highValue');
    return endVal.toString();
  }
}

/// Page 9
/// Data

/// Page 10
/// Forces

/// Page 11
/// currencies
