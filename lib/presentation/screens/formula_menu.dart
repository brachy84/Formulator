import 'package:all_the_formulars/data/formula_data.dart';
import 'package:catex/catex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:all_the_formulars/buisness_logic/formula_bloc.dart';
import 'package:all_the_formulars/data/formula.dart';
import 'package:all_the_formulars/data/localization.dart';

FormulaPath formulaPath = FormulaPath();

class FormulaMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: Formulas.formulaData.length,
          itemBuilder: (context, index) {
            if (Formulas.formulaData[index] is Formula) {
              return FormulaWidget(
                parent: null,
                formula: Formulas.formulaData[index],
              );
            } else {
              return CategoryWidget(
                parent: null,
                category: Formulas.formulaData[index],
              );
            }
          }),
    );
  }
}

class FormulaWidget extends StatelessWidget {
  final CategoryWidget parent;
  final Formula formula;

  const FormulaWidget({
    Key key,
    this.parent,
    this.formula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return GestureDetector(
      onTap: () {
        // change formula screen
        String name = L.formula.get(formula.name);
        formulaPath.formula = name;
        BlocProvider.of<FormulaBloc>(context)
            .add(FormulaSelectedEvent(formula, formulaPath));
      },
      child: ListTile(
        title: Text(L.formula.get(formula.name)),
        subtitle: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 10),
            child: CaTeX(Formula.toCaTeX(formula.formula))),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final CategoryWidget parent;
  final FormulaCategory category;

  const CategoryWidget({
    Key key,
    this.parent,
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
        onExpansionChanged: (val) {
          String name = L.formula.get(category.name);
          if (val) {
            formulaPath.append(name);
            // close all other tiles
          } else {
            formulaPath.remove(name);
          }
        },
        children: List.generate(category.content.length,
            (index) => buildChild(category.content[index], this)),
      ),
    );
  }

  Widget buildChild(FormulaBase base, CategoryWidget parent) {
    return base is Formula
        ? FormulaWidget(
            parent: parent,
            formula: base,
          )
        : CategoryWidget(
            parent: parent,
            category: base,
          );
  }
}
