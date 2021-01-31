import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/presentation/screens/conversion.dart';
import 'package:all_the_formulars/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:all_the_formulars/data/unit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversionMenu extends StatelessWidget {
  ConversionMenu({Key key}) : super(key: key);

  final List<Widget> conversionTiles = [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // first row
        ConversionMenuTile(
          unit: Units.lengths,
          name: 'lengths',
          iconData: FontAwesomeIcons.ruler,
          color: Colors.blue,
        ),
        ConversionMenuTile(
          unit: Units.area,
          name: 'areas',
          iconData: FontAwesomeIcons.rulerCombined,
          color: Colors.green,
        ),
        ConversionMenuTile(
          unit: Units.volume,
          name: 'volumes',
          iconData: FontAwesomeIcons.diceD6,
          color: Colors.red,
        )
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // first row
        ConversionMenuTile(
          unit: Units.temperatur,
          name: 'temperaturs',
          iconData: FontAwesomeIcons.temperatureHigh,
          color: Colors.blue[100],
        ),
        ConversionMenuTile(
          unit: Units.weight,
          name: 'weight',
          iconData: FontAwesomeIcons.weightHanging,
          color: Colors.orange,
        )
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    // tiles in a 3 wide grid
    // a tile is 3 wide and 4 high
    // the icon is colored in the middle
    // at the bottom is the name
    // grid is scrollable
    // tiles have shadows
    // maybe tiles are animated
    // maybe hero animation from Tile to conversion screen
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: conversionTiles,
        ));
  }
}

class ConversionMenuTile extends StatelessWidget {
  final Unit unit;
  String name;
  IconData iconData;
  Color color;

  Icon icon;

  ConversionMenuTile({
    Key key,
    @required this.unit,
    @required this.name,
    @required this.iconData,
    this.color = Colors.black,
  }) : super(key: key) {
    //assert(icon is Icon || icon is FaIcon);
    icon = Icon(
      iconData,
      color: color,
    );
  }
  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    final screenSize = MediaQuery.of(context).size;
    double tileWidth = screenSize.width / 21 * 5;
    double tileHeight = tileWidth / 3 * 4;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversionScreen(
                    unit: unit,
                    name: name,
                    icon: icon,
                    color: color,
                  ))),
      child: Container(
        margin: EdgeInsets.only(bottom: 16, top: 16),
        constraints: BoxConstraints(
            maxHeight: tileHeight,
            minHeight: tileHeight,
            maxWidth: tileWidth,
            minWidth: tileWidth),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.5),
                  offset: Offset(0, 0),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [icon, Text(L.conversion.get(name))],
        ),
      ),
    );
  }
}
