import 'package:all_the_formulars/buisness_logic/conversion_bloc.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/old/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:all_the_formulars/data/unit.dart';

class ConversionScreen extends StatelessWidget {
  final Unit unit;
  String name;
  Widget icon;
  Color color;

  Map<String, TextEditingController> controllers = {};

  ConversionScreen({
    Key key,
    @required this.unit,
    @required this.name,
    @required this.icon,
    @required this.color,
  }) : super(key: key) {
    assert(icon is Icon || icon is FaIcon);
  }

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return BlocProvider(
      create: (context) => ConversionBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(L.conversion.get(name)),
          elevation: 0,
        ),
        body: Container(
            child: ListView(
          children: buildUnitTextFields(),
        )),
      ),
    );
  }

  List<Widget> buildUnitTextFields() {
    List<Widget> widgets = [];
    unit.keys.forEach((key) {
      final _controller = TextEditingController();
      widgets.add(UnitTextField(
        unit: unit,
        short: key[0],
        name: key[1],
      ));
    });
    return widgets;
  }
}

class UnitTextField extends StatelessWidget {
  final Unit unit;
  final String short;
  final String name;

  const UnitTextField({Key key, this.unit, this.short, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return Container(
      padding: EdgeInsets.only(left: 12, right: 4, top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: BlocBuilder<ConversionBloc, ConversionState>(
              buildWhen: (previous, current) {
                if (current.unit == null && current.inputUnit == null)
                  return true;
                if (current.inputUnit != short &&
                    current.unit == unit &&
                    ((current.inputValue != previous.inputValue) ||
                        (current.inputUnit != previous.inputValue))) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                double convertedValue;
                if (state.unit == null && state.inputUnit == null) {
                  convertedValue = 0;
                } else {
                  print(
                      'Calculating converrtedValue with value ${state.inputValue}');
                  convertedValue = Utils.dp(
                      unit.convertTo(state.inputUnit, short, state.inputValue),
                      6);
                }
                TextEditingController _controller =
                    TextEditingController(text: convertedValue.toString());
                return TextField(
                  controller: _controller,
                  onChanged: (val) {
                    print('OnChnaged of $short');
                    BlocProvider.of<ConversionBloc>(context).add(ChangedEvent(
                        unit: unit, value: double.parse(val), fromUnit: short));
                    //context.read()<ConversionBloc>().add(ChangedEvent(
                    //    unit: unit, value: double.parse(val), fromUnit: name));
                  },
                  onTap: () {
                    _controller.selection = TextSelection(
                        baseOffset: 0, extentOffset: _controller.text.length);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          gapPadding: 2),
                      labelText: short),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Expanded(child: Text(L.conversion.get(name)))
        ],
      ),
    );
  }
}
