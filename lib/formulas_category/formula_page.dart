import 'package:all_the_formulars/core/widgets/widgets.dart';
import 'package:all_the_formulars/main.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'formula_page_home.dart';

void initController(List<Item> data) {
  if (data.first.controllerList == null ||
      data.first.controllerList.length < 1) {
    data.forEach((item) {
      item.formula.variables.forEach((variable) {
        item.controllerList.add(TextEditingController());
      });
      if (item.subItems != null && item.subItems.length > 0) {
        item.subItems.forEach((subItem) {
          subItem.formula.variables.forEach((variable) {
            subItem.controllerList.add(TextEditingController());
          });
        });
      }
    });
  }
}

void disposeController(List<Item> data) {
  if (data.first.controllerList != null ||
      data.first.controllerList.length > 0) {
    data.forEach((item) {
      item.controllerList.forEach((controller) {
        controller.dispose();
      });
      item.controllerList.clear();
      if (item.subItems != null && item.subItems.length > 0) {
        item.subItems.forEach((subItem) {
          subItem.controllerList.forEach((controller) {
            controller.dispose();
          });
          subItem.controllerList.clear();
        });
      }
    });
  }
}

class FormulaCategoryBase extends StatelessWidget {
  String categoryName;
  List<FormulaSubCategoryBase> subCategories;

  FormulaCategoryBase({this.categoryName, this.subCategories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: getSubCategoryCard(subCategories, context),
          ),
        ));
  }
}

List<Widget> getSubCategoryCard(
    List<FormulaSubCategoryBase> subCategories, BuildContext context) {
  List<Widget> widgets = [];
  subCategories.forEach((subCategory) {
    widgets.add(Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: subCategory.color, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: subCategory.icon,
        title: Text(subCategory.name),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => subCategory));
            //FormulaSubCategoryBase(name: subCategory.name, color: subCategory.color, icon: subCategory.icon, data: subCategory.data,)
          },
        ),
      ),
    ));
  });
  return widgets;
}

class FormulaSubCategoryBase extends StatefulWidget {
  String name;
  Color color;
  Widget icon;
  List<Item> data;

  FormulaSubCategoryBase(
      {@required this.name, this.color, this.icon, @required this.data}) {
    color ??= Colors.grey;
    icon ??= FaIcon(FontAwesomeIcons.plus);
    if (icon is! Icon && icon is! FaIcon) {
      throw Exception(
          'Icon of [FormulaSubCategoryBase] needs to be either [Icon] or [FaIcon]');
    }
  }

  @override
  _FormulaSubCategoryBaseState createState() =>
      _FormulaSubCategoryBaseState(name, color, icon, data);
}

class _FormulaSubCategoryBaseState extends State<FormulaSubCategoryBase>
    with TickerProviderStateMixin {
  String name;
  Color color;
  Widget icon;
  List<Item> data;

  _FormulaSubCategoryBaseState(this.name, this.color, this.icon, this.data);

  @override
  void initState() {
    initController(data);
    data.forEach((item) {
      item.animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300));
    });
    super.initState();
  }

  @override
  void dispose() {
    disposeController(data);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: ListView(
            children: buildFormulaTile(),
          ),
        ));
  }

  List<Widget> buildFormulaTile() {
    List<Widget> widgets = [];
    int i = 0;
    data.forEach((item) {
      if (i != null) {
        widgets.add(Divider());
      }
      widgets.add(OpenContainer(
        transitionType: ContainerTransitionType.fade,
        transitionDuration: Duration(milliseconds: 500),
        closedColor: appliedTheme.canvasColor,
        closedElevation: 0,
        closedBuilder: (context, action) {
          return ListTile(
              title: Text(item.name), trailing: Icon(Icons.chevron_right));
        },
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        openColor: appliedTheme.cardColor,
        openBuilder: (context, action) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(item.name),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => action(),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
              ),
              body: FormulaItemContainer(
                item: item,
                isCustom: false,
              ));
        },
      ));
      i++;
    });
    return widgets;
  }
}
