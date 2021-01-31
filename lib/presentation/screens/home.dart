import 'package:all_the_formulars/data/localization.dart';
import 'package:flutter/material.dart';

import 'package:all_the_formulars/presentation/screens/conversion_menu.dart';
import 'package:all_the_formulars/presentation/screens/formula_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // has tab bar with conversion menu and formula menu
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final L = LocaleBase.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0,
        bottom: TabBar(
          tabs: [
            TabBarChild(L.main.get('unit_converter')),
            TabBarChild(L.main.get('formulas'))
          ],
          controller: tabController,
        ),
        toolbarHeight: 86,
      ),
      body: Container(
        child: TabBarView(
          children: [ConversionMenu(), FormulaMenu()],
          controller: tabController,
        ),
      ),
    );
  }
}

class TabBarChild extends StatelessWidget {
  const TabBarChild(
    this.text, {
    Key key,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
