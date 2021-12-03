import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/provider/products_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late ThemeData theme;
  late TextEditingController controller;
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late Animation<BorderRadius> radiusAnimation;
  late Animation<Size> sizeAnimation;
  late Size dimensions;

  late ProductsProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);

    dimensions = MediaQuery.of(context).size;
    provider = Provider.of<ProductsProvider>(context);
    sizeAnimation = Tween<Size>(
            begin: Size(0, 0), end: Size(dimensions.width, dimensions.height))
        .animate(
            CurvedAnimation(curve: Curves.linear, parent: animationController));

    animationController.forward();
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    radiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(50), end: BorderRadius.circular(0))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.78))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: sizeAnimation,
        builder: (BuildContext context, Widget? child) {
          return SizedBox(
            height: sizeAnimation.value.height,
            width: sizeAnimation.value.width,
            child: ClipRRect(
              borderRadius: radiusAnimation.value,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: radiusAnimation.value,
                ),
                child: input(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget input(context) {
    return Container(
      height: 60,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 16,
          top: 13,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(),
          child: inputField(context),
        ),
      ),
    );
  }

  Widget inputField(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Hero(
        tag: 'search',
        child: Material(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 16,
              top: 13,
            ),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.search, size: 12),
                Flexible(
                  child: TextField(controller: controller),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
