import 'package:flutter/material.dart';

class SlideShow extends StatefulWidget {
  SlideShow({
    Key key,
    @required this.controller,
  }) : super(key: key);
  final AnimationController controller;

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final PageController ctrl = PageController(viewportFraction: 1);
  Animation<double> fadeIn;

  @override
  void initState() {
    super.initState();
    fadeIn = Tween<double>(begin: 1, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PageView(
        controller: ctrl,
        // scrollDirection: Axis.horizontal,
        children: [
          displayCard('assets/1.png'),
          displayCard('assets/2.png'),
          displayCard('assets/3.png'),
        ],
      ),
    );
  }

  Widget displayCard(String image) {
    return AnimatedBuilder(
      animation: fadeIn,
      builder: (BuildContext context, Widget builderchild) => FadeTransition(
        opacity: fadeIn,
        child: Container(
          margin: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
