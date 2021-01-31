import 'package:all_the_formulars/presentation/theme/themes.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ThemeChangedEvent extends ThemeEvent {
  final ThemeData theme;
  ThemeChangedEvent({
    this.theme,
  });
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(theme: Themes.DARK));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChangedEvent) {
      yield ThemeState(theme: event.theme);
    }
  }
}

class ThemeState {
  final ThemeData theme;
  ThemeState({
    this.theme,
  });
}
