import 'dart:math';

import 'package:flutter/material.dart';

double rad(double d) => d * pi / 180;

class RotateDrawer extends StatefulWidget {
  RotateDrawer(
      {Key key,
      @required this.child,
      @required this.content,
      this.sizeFactor,
      this.translateFactor,
      this.color})
      : super(key: key) {
    sizeFactor ??= 2/3;
    color ??= Colors.blue;
  }

  /// The Widget to display when the drawer is closed i.e. a Scaffold tree
  Widget child;

  /// The content of the drawer
  Widget content;

  /// How much smaller than the users screen will the [child] become when the drawer is opened
  /// 0.5 would be half the size of the users screen.
  /// default is 2/3 -> 0.66666
  double sizeFactor;

  /// By how much the child will be translated to the right
  /// default is the screen width so the middle of [child] is exactly at the edge of the screen
  double translateFactor;

  /// The background color of the opened Drawer
  /// Default is [Colors.blue]
  Color color;
  @override
  RotateDrawerState createState() => RotateDrawerState();
}

class RotateDrawerState extends State<RotateDrawer>
    with SingleTickerProviderStateMixin {
  double screenWidth = 200;
  AnimationController animationController;

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  void open() {
    if (animationController.isDismissed) animationController.forward();
  }

  void close() {
    if (animationController.isCompleted) animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    animationController ??=
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;

    return Material(
      child: GestureDetector(
        //onTap: toggle,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        //onTap: toggleDrawer,
        child: Container(
          constraints: BoxConstraints.expand(
              width: double.infinity, height: double.infinity),
          color: widget.color,
          child: AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                return Stack(
                  children: [
                    //drawer
                    Transform.translate(
                      offset: Offset(screenWidth * widget.sizeFactor * (animationController.value - 1), 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(pi / 2 * (1- animationController.value)),
                        alignment: Alignment.centerRight,
                        child: Container(
                            constraints: BoxConstraints(
                                maxHeight: double.infinity,
                                maxWidth: screenWidth * widget.sizeFactor),
                            child: widget.content),
                      ),
                    ),
                    // normal view
                    GestureDetector(
                      //onTap: close,
                      child: Transform.translate(
                        offset: Offset(screenWidth * widget.sizeFactor * animationController.value, 0),
                        child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(-pi / 2 * animationController.value),
                            alignment: Alignment.centerLeft,
                            child: widget.child),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  bool _canBeDragged = false;
  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        animationController.isDismissed && details.globalPosition.dx < 150;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx > 0;
    _canBeDragged = isDragCloseFromRight || isDragOpenFromLeft;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / screenWidth;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / screenWidth;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}
