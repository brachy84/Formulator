import 'package:bloc/bloc.dart';

import 'package:all_the_formulars/data/unit.dart';

abstract class ConversionEvent {}

class ChangedEvent extends ConversionEvent {
  final Unit unit;
  final String fromUnit;
  final double value;
  ChangedEvent({
    this.unit,
    this.fromUnit,
    this.value,
  }) {
    print('New ConversionBloc event with value $value');
  }
}

class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  ConversionBloc() : super(ConversionState(inputValue: 0));

  @override
  Stream<ConversionState> mapEventToState(ConversionEvent event) async* {
    if (event is ChangedEvent) {
      print(
          'Called ChangedEvent with fromUnit: ${event.fromUnit} and value: ${event.value}');
      yield ConversionState(
          unit: event.unit, inputUnit: event.fromUnit, inputValue: event.value);
    }
  }
}

class ConversionState {
  final Unit unit;
  final double inputValue;
  final String inputUnit;
  const ConversionState({
    this.unit,
    this.inputValue,
    this.inputUnit,
  });
}
