import 'package:all_the_formulars/buisness_logic/conversion_bloc.dart';
import 'package:all_the_formulars/buisness_logic/currency_bloc.dart';
import 'package:all_the_formulars/data/currency_data.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/utils.dart';
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
                TextEditingController _controller = TextEditingController(
                    text: convertedValue <= 9223372036854.775
                        ? L.main.get('value_to_high')
                        : convertedValue.toString());
                return TextField(
                  controller: _controller,
                  onChanged: (val) {
                    print('OnChnaged of $short');
                    BlocProvider.of<ConversionBloc>(context).add(ChangedEvent(
                        unit: unit, value: double.parse(val), fromUnit: short));
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
                      labelText: L.conversion.get(name)),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Expanded(child: Text(short))
        ],
      ),
    );
  }
}

class CurrencyConversionScreen extends StatelessWidget {
  CurrencyConversionScreen({Key key}) : super(key: key);
  List<DropdownMenuItem<String>> currencyList = [];

  String exchangeCurrency1 = 'EUR';
  double exchangeValue1;
  TextEditingController _currency1Controller =
      TextEditingController(text: '1.0');
  String exchangeCurrency2 = 'USD';
  double exchangeValue2;
  String currency2Text = '';

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(L.conversion.get('currency')),
      ),
      body: Container(
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if (state.isLoaded) {
              if (currencyList.length == 0) {
                currencyList = CurrencyData.exchangeRates.keys.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 186),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(L.currency.get(e.toLowerCase()))),
                          Text('  |  '),
                          Expanded(child: Text(e))
                        ],
                      ),
                    ),
                    //child: Text(e),
                  );
                }).toList();
                print('DropDownData');
              }
              exchangeCurrency1 = state.inputCurrency;
              exchangeCurrency2 = state.outputCurrency;
              exchangeValue1 = CurrencyData.exchangeRates[exchangeCurrency1];
              exchangeValue2 = CurrencyData.exchangeRates[exchangeCurrency2];

              currency2Text = CurrencyData.convertTo(
                      exchangeCurrency1, exchangeCurrency2, state.inputValue)
                  .toString();

              return Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
                    child: Text(L.main.get('last_updated') +
                        ': ${CurrencyData.lastUpdated}'),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16)),
                  DropdownButton<String>(
                    value: exchangeCurrency1,
                    icon: Icon(Icons.arrow_drop_down),
                    items: currencyList,
                    onChanged: (val) {
                      BlocProvider.of<CurrencyBloc>(context)
                          .add(CurrencyChangeIOEvent(inputCurrency: val));
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32, right: 32, bottom: 8),
                    constraints: BoxConstraints(
                        minWidth: double.infinity,
                        maxHeight: 40,
                        minHeight: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: _currency1Controller,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          //textAlignVertical: TextAlignVertical(y: -1),
                          onChanged: (val) {
                            BlocProvider.of<CurrencyBloc>(context).add(
                                CurrencyChangeValueEvent(
                                    inputValue: double.parse(val)));

                            //setState(() => calculateValues(val));
                          },
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.unfold_more, size: 32),
                    onPressed: () {
                      BlocProvider.of<CurrencyBloc>(context).add(
                          CurrencyChangeIOEvent(
                              inputCurrency: exchangeCurrency2,
                              outputCurrency: exchangeCurrency1));
                    },
                  ),
                  DropdownButton<String>(
                    value: exchangeCurrency2,
                    icon: Icon(Icons.arrow_drop_down),
                    items: currencyList,
                    onChanged: (val) {
                      BlocProvider.of<CurrencyBloc>(context)
                          .add(CurrencyChangeIOEvent(outputCurrency: val));
                    },
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 0, left: 32, right: 32),
                      constraints: BoxConstraints(
                          minWidth: double.infinity,
                          maxHeight: 40,
                          minHeight: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            currency2Text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )),
                ],
              );
            } else {
              return Center(child: Text('loading'));
            }
          },
        ),
      ),
    );
  }
}
