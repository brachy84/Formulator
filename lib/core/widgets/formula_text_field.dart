import 'package:all_the_formulars/core/formula/formula2.dart';
import 'package:catex/catex.dart';
import 'package:flutter/material.dart';

class FormulaTextController {
  String formula;

  void addDivider() {
    formula += r':{ $ }/{ $ }';
  }

  void addRoot() {
    formula += r'√{ $ }';
  }

  void removeLast() {}
}

class FormulaTextField extends StatefulWidget {
  FormulaTextController controller;
  TextStyle style;

  FormulaTextField({this.controller, this.style});

  @override
  _FormulaTextFieldState createState() => _FormulaTextFieldState();
}

class _FormulaTextFieldState extends State<FormulaTextField> {
  String raw;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    raw = widget.controller.formula;

    return Stack(
      children: [
        DefaultTextStyle.merge(
            style: widget.style.copyWith(color: Color.fromARGB(0, 0, 0, 0)),
            child: CaTeX(Formula2.toCaTeXstatic(raw.split(' '))))
      ],
    );
  }

  List<Widget> generateRow() {
    List<Widget> widgets = [];
    List<String> rawParts = raw
        .replaceAll(' ', '')
        .split(RegExp('(:{|}/{|}|√{)'))
        .where((e) => e != '')
        .toList();
  }

  Widget generate(String content) {}

  Widget generateDivider(String top, String bottom) {}

  Widget generateRoot(String content) {}

  Widget generateSuperscript(String content) {}

  Widget generateSubscript(String content) {}
}
