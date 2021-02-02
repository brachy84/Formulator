import 'dart:ui';
import 'package:flutter/material.dart';

class SlideScaleDrawer extends StatefulWidget {
  SlideScaleDrawer(
      {Key key,
      @required this.child,
      @required this.content,
      this.sizeFactor,
      this.translateFactor,
      this.color})
      : super(key: key) {
    sizeFactor ??= 1 / 3;
    color ??= Colors.blue;
  }

  /// The Widget to display when the drawer is closed i.e. a Scaffold tree
  Widget child;

  /// The content of the drawer
  Widget content;

  /// How much smaller than the users screen will the [child] become when the drawer is opened
  /// 0.5 would be half the size of the users screen. 0.7 would be 1/7
  /// default is 1/3
  double sizeFactor;

  /// By how much the child will be translated to the right
  /// default is the screen width so the middle of [child] is exactly at the edge of the screen
  double translateFactor;

  /// The background color of the opened Drawer
  /// Default is [Colors.blue]
  Color color;

  @override
  SlideScaleDrawerState createState() => SlideScaleDrawerState();
}

class SlideScaleDrawerState extends State<SlideScaleDrawer>
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
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
    widget.translateFactor ??= screenWidth;

    return Material(
      child: Container(
        constraints: BoxConstraints.expand(
            width: double.infinity, height: double.infinity),
        color: widget.color,
        child: GestureDetector(
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          //onTap: toggleDrawer,
          child: AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                double slide =
                    widget.translateFactor * animationController.value;
                double scale =
                    1 - (animationController.value * widget.sizeFactor);
                return Stack(
                  children: [
                    //drawer
                    Container(
                        constraints: BoxConstraints(
                            maxHeight: double.infinity,
                            maxWidth: screenWidth * (1 - widget.sizeFactor) -
                                (screenWidth - widget.translateFactor)),
                        child: widget.content),
                    // normal view
                    GestureDetector(
                      onTap: close,
                      child: Transform(
                          transform: Matrix4.identity()
                            ..scale(scale)
                            ..translate(slide),
                          alignment: Alignment.centerLeft,
                          child: widget.child),
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
        animationController.isDismissed && details.globalPosition.dx < 70;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx > screenWidth * (1 - widget.sizeFactor);
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
