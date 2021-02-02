import 'package:all_the_formulars/buisness_logic/formula_bloc.dart';
import 'package:all_the_formulars/data/localization.dart';
import 'package:flutter/material.dart';

import 'package:all_the_formulars/data/formula.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormulaMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: Formulas.formulaData.length,
          itemBuilder: (context, index) {
            if (Formulas.formulaData[index] is Formula) {
              return FormulaWidget(
                formula: Formulas.formulaData[index],
              );
            } else {
              return CategoryWidget(
                category: Formulas.formulaData[index],
              );
            }
          }),
    );
  }
}

class FormulaWidget extends StatelessWidget {
  final Formula formula;

  const FormulaWidget({
    Key key,
    this.formula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return GestureDetector(
      onTap: () {
        // change formula screen
        BlocProvider.of<FormulaBloc>(context)
            .add(FormulaSelectedEvent(formula));
      },
      child: ListTile(
        title: Text(L.formula.get(formula.name)),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final FormulaCategory category;

  const CategoryWidget({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return Container(
      child: ExpansionTile(
        title: Text(L.formula.get(category.name)),
        //tilePadding: EdgeInsets.all(0),
        childrenPadding: EdgeInsets.only(left: 8),
        children: List.generate(category.content.length,
            (index) => buildChild(category.content[index])),
      ),
    );
  }

  Widget buildChild(FormulaBase base) {
    return base is Formula
        ? FormulaWidget(
            formula: base,
          )
        : CategoryWidget(
            category: base,
          );
  }
}
