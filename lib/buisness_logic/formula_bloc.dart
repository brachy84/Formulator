import 'package:all_the_formulars/data/formula_data.dart';
import 'package:all_the_formulars/utils.dart';
import 'package:bloc/bloc.dart';

import 'package:all_the_formulars/data/formula.dart';
import 'package:all_the_formulars/data/unit.dart';

abstract class FormulaEvent {}

class FormulaSelectedEvent extends FormulaEvent {
  final Formula formula;
  final FormulaPath path;
  FormulaSelectedEvent(
    this.formula,
    this.path,
  );
}

class FormulaChangeResultEvent extends FormulaEvent {
  final String selectedResult;
  FormulaChangeResultEvent({
    this.selectedResult,
  });
}

class FormulaChangeUnitEvent extends FormulaEvent {
  final Map<String, String> variableUnits;
  FormulaChangeUnitEvent({
    this.variableUnits,
  });
}

class FormulaChangeInputValueEvent extends FormulaEvent {
  final Map<String, double> inputValues;
  FormulaChangeInputValueEvent(
    this.inputValues,
  );
}

class FormulaCalculateEvent extends FormulaEvent {}

class FormulaBloc extends Bloc<FormulaEvent, FormulaState> {
  // use last opened formula saved with shared preferences

  FormulaBloc()
      : super(FormulaState(
            formula: Formulas.triangleArea,
            selectedResult: Formulas.triangleArea.defaultResult,
            variableUnits: Formulas.triangleArea.varData.map((key, value) {
              return MapEntry<String, String>(key, value[2]);
            }),
            path: FormulaPath()));

  @override
  Stream<FormulaState> mapEventToState(FormulaEvent event) async* {
    if (event is FormulaSelectedEvent) {
      Map<String, String> _initVariableUnits =
          event.formula.varData.map((key, value) {
        return MapEntry<String, String>(key, value[2]);
      });
      yield FormulaState(
          formula: event.formula,
          selectedResult: event.formula.defaultResult,
          variableUnits: _initVariableUnits,
          inputValues: null,
          path: event.path);
    } else if (event is FormulaChangeResultEvent) {
      yield state.copyWith(selectedResult: event.selectedResult);
    } else if (event is FormulaChangeUnitEvent) {
      Map<String, String> _varUnits = Map.from(state.variableUnits);
      _varUnits.addAll(event.variableUnits);
      yield state.copyWith(variableUnits: _varUnits);
    } else if (event is FormulaCalculateEvent) {
      // recalculate values with changed units
      Map<String, double> newValues = state.inputValues.map((variable, value) {
        Unit unit = state.formula.unitOf(variable);
        double converrtedValue = unit.convertTo(state.variableUnits[variable],
            state.formula.defaultUnit(variable), value);
        return MapEntry(variable, converrtedValue);
      });
      double result = state.formula.calculate(state.selectedResult, newValues);
      result = Utils.dp(result, 6);
      yield state.copyWith(result: result);
    } else if (event is FormulaChangeInputValueEvent) {
      Map<String, double> _inputValues =
          state.inputValues != null ? Map.from(state.inputValues) : {};
      _inputValues.addAll(event.inputValues);
      print('On text change: inputValues: $_inputValues');
      yield state.copyWith(inputValues: _inputValues);
    }
  }
}

class FormulaState {
  Formula formula;
  String selectedResult;
  Map<String, String> variableUnits;
  Map<String, double> inputValues;
  double result;
  FormulaPath path;

  FormulaState({
    this.formula,
    this.selectedResult,
    this.variableUnits,
    this.inputValues,
    this.result,
    this.path,
  });

  FormulaState copyWith({
    Formula formula,
    String selectedResult,
    Map<String, String> variableUnits,
    Map<String, double> inputValues,
    double result,
    String path,
  }) {
    return FormulaState(
      formula: formula ?? this.formula,
      selectedResult: selectedResult ?? this.selectedResult,
      variableUnits: variableUnits ?? this.variableUnits,
      inputValues: inputValues ?? this.inputValues,
      result: result ?? this.result,
      path: path ?? this.path,
    );
  }
}
