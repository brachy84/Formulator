import 'package:catex/catex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:all_the_formulars/buisness_logic/formula_bloc.dart';
import 'package:all_the_formulars/data/formula.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/presentation/theme/colors.dart';

class FormulaScreen extends StatelessWidget {
  final GlobalKey scaffoldKey;
  const FormulaScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return BlocBuilder<FormulaBloc, FormulaState>(
      buildWhen: (previous, current) =>
          (previous.formula.formula != current.formula.formula),
      builder: (context, state) {
        final formula = state.formula;
        final List<DropdownMenuItem<String>> changeToValues =
            formula.varData.keys.map((e) {
          return DropdownMenuItem<String>(
            child: CaTeX(e),
            value: e,
          );
        }).toList();
        return Container(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 4),
                //color: Theme.of(context).primaryColor,
                child: Text(
                  state.path.fullPath,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    L.formula.get(formula.name),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(L.formula.get(formula.description)),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                    color: MoreColors.darkBlueGrey[500],
                    borderRadius: BorderRadius.circular(24)),
                child: BlocBuilder<FormulaBloc, FormulaState>(
                  buildWhen: (previous, current) =>
                      previous.selectedResult != current.selectedResult ||
                      (previous.result == null && current.result != null) ||
                      previous.result != current.result ||
                      previous.formula != current.formula,
                  builder: (context, state) {
                    return Row(
                      children: [
                        DefaultTextStyle.merge(
                            style: TextStyle(fontSize: 22),
                            child: CaTeX(Formula.toCaTeX(state.formula
                                .changeTo(result: state.selectedResult)))),
                        if (state.result != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: DefaultTextStyle.merge(
                                style: TextStyle(fontSize: 22),
                                child: CaTeX('=')),
                          ),
                          Text(
                            state.result.toString(),
                            style: TextStyle(fontSize: 22),
                          )
                        ]
                      ],
                    );
                  },
                ),
              ),
              Row(children: [
                Container(
                    margin: EdgeInsets.only(left: 16, right: 8),
                    child: Text(L.main.get('change_to') + ':')),
                BlocBuilder<FormulaBloc, FormulaState>(
                  buildWhen: (previous, current) =>
                      previous.selectedResult != current.selectedResult,
                  builder: (context, state) {
                    return DropdownButton(
                        items: changeToValues,
                        value: state.selectedResult,
                        onChanged: (val) {
                          BlocProvider.of<FormulaBloc>(context).add(
                              FormulaChangeResultEvent(selectedResult: val));
                        });
                  },
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(maxHeight: 32),
                  decoration: BoxDecoration(
                      color: Theme.of(context).buttonColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: MaterialButton(
                      child: Text(L.main.get('calculate')),
                      onPressed: () {
                        //calculate
                        bool allValuesSet = true;
                        if (state.inputValues != null) {
                          formula.varData.keys.forEach((variable) {
                            if (variable != state.selectedResult &&
                                !state.inputValues.containsKey(variable)) {
                              allValuesSet = false;
                            }
                          });
                        }

                        if (!allValuesSet) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(L.main.get('values_not_set'))));
                        } else {
                          BlocProvider.of<FormulaBloc>(context)
                              .add(FormulaCalculateEvent());
                        }
                      }),
                )
              ]),
              ...buildLegend(state.formula)
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildLegend(Formula formula) {
    List<Widget> widgets = [];
    formula.varData.forEach((variable, data) {
      if (formula.varData.keys.first != variable) {
        widgets.add(Divider());
      }
      widgets.add(VariableLine(
        variable: variable,
        formula: formula,
      ));
    });
    return widgets;
  }
}

class VariableLine extends StatelessWidget {
  final String variable;
  final Formula formula;

  const VariableLine({
    Key key,
    this.variable,
    this.formula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return BlocBuilder<FormulaBloc, FormulaState>(
      buildWhen: (previous, current) {
        bool shouldRebuild = false;
        if (variable == current.selectedResult) {
          if ((previous.result == null && current.result != null) ||
              previous.result != current.result) {
            shouldRebuild = true;
          }
        }

        if (previous.inputValues == null ||
            previous.inputValues[variable] == null) {
          if (current.inputValues != null &&
              current.inputValues[variable] != null) {
            shouldRebuild = true;
          }
        }

        if (previous.variableUnits[variable] !=
            current.variableUnits[variable]) {
          shouldRebuild = true;
        }
        return shouldRebuild;
      },
      builder: (context, state) {
        TextEditingController _controller = TextEditingController();
        if (state.selectedResult == variable && state.result != null) {
          BlocProvider.of<FormulaBloc>(context)
              .add(FormulaChangeInputValueEvent({variable: state.result}));
        }

        if (state.inputValues != null &&
            state.inputValues.containsKey(variable)) {
          if (state.selectedResult == variable &&
              state.variableUnits[variable] != formula.defaultUnit(variable)) {
            double result = state.inputValues[variable];
            result = formula
                .unitOf(variable)
                .convertFromDefault(state.variableUnits[variable], result);
            _controller = TextEditingController(
              text: result.toString(),
            );
          } else {
            _controller = TextEditingController(
              text: state.inputValues[variable].toString(),
            );
          }
        }
        return Row(
          children: [
            Expanded(flex: 2, child: CaTeX(variable)),
            Expanded(
                flex: 7, child: Text(L.formula.get(formula.meaning(variable)))),
            Expanded(
                flex: 8,
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  constraints: BoxConstraints(maxHeight: 40),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12, right: 12),
                        labelText: L.main.get('value'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onChanged: (val) {
                      BlocProvider.of<FormulaBloc>(context).add(
                          FormulaChangeInputValueEvent(
                              {variable: double.parse(val)}));
                    },
                  ),
                )),
            Expanded(
              flex: 4,
              child: DropdownButton(
                  items: formula.unitOf(variable).getDropdownList(),
                  value: state.variableUnits[variable],
                  onChanged: (val) {
                    BlocProvider.of<FormulaBloc>(context).add(
                        FormulaChangeUnitEvent(variableUnits: {variable: val}));
                  }),
            )
          ],
        );
      },
    );
  }
}
