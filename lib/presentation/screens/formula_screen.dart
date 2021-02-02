import 'package:all_the_formulars/buisness_logic/formula_bloc.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:flutter/material.dart';

import 'package:all_the_formulars/data/formula.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormulaScreen extends StatelessWidget {
  const FormulaScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return BlocBuilder<FormulaBloc, FormulaState>(
      builder: (context, state) {
        final formula = state.formula;
        return Scaffold(
          appBar: AppBar(
            title: Text(L.formula.get(formula.name)),
          ),
          body: Container(
            child: Column(
              children: [Text(L.formula.get(formula.description))],
            ),
          ),
        );
      },
    );
  }
}
