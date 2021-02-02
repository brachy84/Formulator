import 'package:bloc/bloc.dart';

import 'package:all_the_formulars/data/formula.dart';

abstract class FormulaEvent {}

class FormulaSelectedEvent extends FormulaEvent {
  final Formula formula;
  FormulaSelectedEvent(
    this.formula,
  );
}

class FormulaBloc extends Bloc<FormulaEvent, FormulaState> {
  // use last opened formula saved with shared preferences
  FormulaBloc() : super(FormulaState(formula: Formulas.triangleArea));

  @override
  Stream<FormulaState> mapEventToState(FormulaEvent event) async* {
    if (event is FormulaSelectedEvent) {
      yield FormulaState(formula: event.formula);
    }
  }
}

class FormulaState {
  Formula formula;
  FormulaState({
    this.formula,
  });
}
