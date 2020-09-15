import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/provider/products_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  ThemeData theme;
  AnimationController animationController;
  Animation<Offset> offsetAnimation;
  Animation<BorderRadius> radiusAnimation;
  Animation<Size> sizeAnimation;
  Size dimensions;

  ProductsProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);

    dimensions = MediaQuery.of(context).size;
    provider = Provider.of<ProductsProvider>(context);
    sizeAnimation = Tween<Size>(
            begin: Size(20, 20), end: Size(dimensions.width, dimensions.height))
        .animate(
            CurvedAnimation(curve: Curves.linear, parent: animationController));

    animationController.forward();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    radiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(20), end: BorderRadius.circular(0))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.78))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (BuildContext context, Widget child) {
        return SizedBox(
          height: sizeAnimation.value.height,
          width: sizeAnimation.value.width,
          child: AnimatedBuilder(
              animation: radiusAnimation,
              builder: (BuildContext context, Widget child) {
                return ClipRRect(
                  borderRadius: radiusAnimation.value,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.red,
                      )),
                );
              }),
        );
      },
    );
  }
}
