import 'package:bloc/bloc.dart';

abstract class CurrencyEvent {}

class CurrencyLoadingEvent extends CurrencyEvent {}

class CurrencyLoadedEvent extends CurrencyEvent {}

class CurrencyChangeIOEvent extends CurrencyEvent {
  String inputCurrency;
  String outputCurrency;
  CurrencyChangeIOEvent({
    this.inputCurrency,
    this.outputCurrency,
  });
}

class CurrencyChangeValueEvent extends CurrencyEvent {
  double inputValue;
  CurrencyChangeValueEvent({
    this.inputValue,
  });
}

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc()
      : super(CurrencyState(
            isLoaded: false,
            inputCurrency: 'EUR',
            outputCurrency: 'USD',
            inputValue: 1.0));

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if (event is CurrencyLoadingEvent) {
      yield state.copyWith(isLoaded: false);
    } else if (event is CurrencyLoadedEvent) {
      yield state.copyWith(isLoaded: true);
    } else if (event is CurrencyChangeIOEvent) {
      yield state.copyWith(
          inputCurrency: event.inputCurrency,
          outputCurrency: event.outputCurrency);
    } else if (event is CurrencyChangeValueEvent) {
      yield state.copyWith(inputValue: event.inputValue);
    }
  }
}

class CurrencyState {
  bool isLoaded;
  String inputCurrency;
  String outputCurrency;
  double inputValue;

  CurrencyState({
    this.isLoaded,
    this.inputCurrency,
    this.outputCurrency,
    this.inputValue,
  });

  CurrencyState copyWith({
    bool isLoaded,
    String inputCurrency,
    String outputCurrency,
    double inputValue,
  }) {
    return CurrencyState(
      isLoaded: isLoaded ?? this.isLoaded,
      inputCurrency: inputCurrency ?? this.inputCurrency,
      outputCurrency: outputCurrency ?? this.outputCurrency,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}
