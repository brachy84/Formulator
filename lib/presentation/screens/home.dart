import 'package:all_the_formulars/data/localization.dart';
import 'package:all_the_formulars/presentation/screens/formula_screen.dart';
import 'package:all_the_formulars/presentation/theme/colors.dart';
import 'package:all_the_formulars/presentation/widgets/slide_scale_drawer.dart';
import 'package:flutter/material.dart';

import 'package:all_the_formulars/presentation/screens/conversion_menu.dart';
import 'package:all_the_formulars/presentation/screens/formula_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // has tab bar with conversion menu and formula menu
  TabController tabController;
  GlobalKey<SlideScaleDrawerState> drawerKey =
      GlobalKey<SlideScaleDrawerState>();

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
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: SlideScaleDrawer(
        key: drawerKey,
        color: MoreColors.darkBlueGrey[500],
        sizeFactor: 0.05,
        translateFactor: screenSize.width / 3 * 2,
        content: FormulaMenu(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                if (tabController.index == 1) {
                  drawerKey.currentState.toggle();
                }
              },
            ),
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
              children: [ConversionMenu(), FormulaScreen()],
              controller: tabController,
            ),
          ),
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
