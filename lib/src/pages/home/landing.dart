import 'package:flutter/material.dart';

import 'back_layer.dart';
import 'front_layer.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackLayer(animationController),
          FrontLayer(
            animationController: animationController,
          ),
          sliderDetector()
        ],
      ),
    );
  }

  Widget sliderDetector() {
    return SizedBox.fromSize(
      size: Size.fromWidth(10),
      child:
          GestureDetector(onHorizontalDragUpdate: (DragUpdateDetails details) {
        print(details.delta.dx);
        if (details.delta.dx > 7) animationController.forward();
      }),
    );
  }
}
