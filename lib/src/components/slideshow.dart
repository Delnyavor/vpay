import 'package:flutter/material.dart';

class SlideShow extends StatefulWidget {
  SlideShow({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final AnimationController controller;

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final PageController ctrl = PageController();
  late Animation<double> fadeIn;
  int subListIndex = 0;
  List<String> images = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
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
        // sublist(),
      ],
    );
  }

  Widget mainList() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: PageView(
        controller: ctrl,
        children: images.map((e) => displayCard(e)).toList(),
      ),
    );
  }

  Widget displayCard(String image) {
    return AnimatedBuilder(
      animation: fadeIn,
      builder: (BuildContext context, Widget? builderchild) => FadeTransition(
        opacity: fadeIn,
        child: Hero(
          tag: '0',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget sublist() {
    return AspectRatio(
      aspectRatio: 12,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.95,
          crossAxisCount: 1,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
              borderRadius: BorderRadius.circular(8),
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
