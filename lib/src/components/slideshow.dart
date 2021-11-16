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
  int subListIndex = 0;
  List<String> images = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
  ];
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
    return Column(
      children: [
        mainList(),
        sublist(),
      ],
    );
  }

  Widget mainList() {
    return AspectRatio(
      aspectRatio: 1.2,
      child: PageView(
        controller: ctrl,
        children: images.map((e) => displayCard(e)).toList(),
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
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget sublist() {
    return AspectRatio(
      aspectRatio: 8,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.95,
          crossAxisCount: 1,
          mainAxisSpacing: 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) => subImage(images[index], index),
      ),
    );
  }

  Widget subImage(String image, int index) {
    bool indexed = subListIndex == index;
    return GestureDetector(
      onTap: () {
        setState(
          () {
            subListIndex = index;
            ctrl.animateToPage(index,
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          },
        );
      },
      child: Opacity(
        opacity: indexed ? 1 : 0.6,
        child: Transform.scale(
          scale: indexed ? 0.9 : 0.8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
