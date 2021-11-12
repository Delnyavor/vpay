import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/provider/products_provider.dart';
import 'package:vpay/src/components/category_widgets.dart';
import 'package:vpay/src/components/search_widget.dart';
import 'package:vpay/src/components/slivers.dart';

class FrontLayer extends StatefulWidget {
  final AnimationController animationController;
  FrontLayer({Key key, this.animationController}) : super(key: key);
  @override
  _FrontLayerState createState() => _FrontLayerState();
}

class _FrontLayerState extends State<FrontLayer> with TickerProviderStateMixin {
  ThemeData theme;
  ScrollController controller;
  TabController tabController;
  double deviceWidth;
  ProductsProvider provider;
  List<Category> categories = [];
  Category selectedCategory = Category(name: "");

  bool completed = false;
  Animation<Offset> offsetAnimation;
  Animation<BorderRadius> radiusAnimation;
  Animation<double> scaleAnimation, rotationAnimation;

  Size dimensions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dimensions = MediaQuery.of(context).size;
    theme = Theme.of(context);
    deviceWidth = MediaQuery.of(context).size.width;

    provider = Provider.of<ProductsProvider>(context);
    categories = provider.categories;
    initialiseTabController();

    tabController = TabController(vsync: this, length: categories.length);
    radiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(20))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.85))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    scaleAnimation = Tween<double>(begin: 1, end: 0.85).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.linear));

    rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0.4, 1, curve: Curves.fastOutSlowIn)));
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    tabController = TabController(vsync: this, length: 0);
    widget.animationController.addListener(() {
      if (widget.animationController.isAnimating) {
        if (completed) {
          setState(() {
            completed = false;
            print(completed);
          });
        }
      } else
        setState(() {
          completed = true;
          print(completed);
        });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  void initialiseTabController() {
    if (selectedCategory.name.trim().isEmpty)
      print('empty');
    else
      print(selectedCategory.name);

    if (categories.isNotEmpty) if (selectedCategory.name.isEmpty)
      selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return animatedBuilder(child: frontLayerContents());
  }

  Widget animatedBuilder({Widget child}) {
    return AnimatedBuilder(
      animation: radiusAnimation,
      builder: (context, builderChild) => SlideTransition(
        position: offsetAnimation,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0005)
            ..rotateX(rotationAnimation.value),
          alignment: FractionalOffset.center,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radiusAnimation.value,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black
                          .withOpacity(widget.animationController.value * 0.05),
                      spreadRadius: -4,
                      blurRadius: 15),
                ],
              ),
              child: builderChild,
            ),
          ),
        ),
      ),
      child: child,
    );
  }

  Scaffold frontLayerContents() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: IgnorePointer(ignoring: false, child: scrollView()),
      ),
    );
  }

  CustomScrollView scrollView() {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        sliverAppBar(),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 25, top: 10),
          sliver: SliverHeader(
            floating: true,
            child: SearchWidget(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          sliver: SliverHeader(
            minHeight: 70,
            maxHeight: 70,
            child: tabBar(),
          ),
        ),
        CategoryWidget(
          category: selectedCategory,
        ),
      ],
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      iconTheme: IconThemeData(color: Colors.black87),
      primary: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          if (widget.animationController.isCompleted)
            widget.animationController.reverse();
          else
            widget.animationController.forward();
        },
        icon: Icon(Icons.sort),
      ),
      actions: <Widget>[
        notification(),
        profile(),
      ],
    );
  }

  Widget tabBar() {
    return Theme(
      data: theme.copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: TabBar(
          labelStyle: theme.textTheme.caption.copyWith(
              letterSpacing: 0.4, fontWeight: FontWeight.w500, fontSize: 10),
          controller: tabController,
          labelColor: Colors.black87,
          isScrollable: true,
          unselectedLabelColor: Colors.black38,
          unselectedLabelStyle: theme.textTheme.caption.copyWith(
              letterSpacing: 0.4, fontWeight: FontWeight.w400, fontSize: 10),
          indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
          // indicatorSize: TabBarIndicatorSize.tab,
          // labelPadding: const EdgeInsets.only(left: 20, right: 5),
          onTap: (index) {
            setState(() {
              selectedCategory = categories[index];
            });
          },
          tabs: [
            for (final category in categories)
              tab(
                category.name,
              )
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              spreadRadius: 0,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
      ),
    );
  }

  Widget notification() {
    return Transform.rotate(
      angle: pi * 1.9,
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          FontAwesomeIcons.bell,
          size: 18,
        ),
        //  Icons.notifications_outlined),
      ),
    );
  }

  Widget tab(String label) {
    Color blue = Colors.indigo[400];
    Color white = Colors.white;

    return Tab(
      text: label,
      icon: DecoratedBox(
        decoration: BoxDecoration(
            color: label == selectedCategory.name ? blue : white,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(
                width: 0.5,
                color: Colors.blueGrey.withOpacity(0.5),
              ),
            )
            // boxShadow: [BoxShadow(color: Colors.blueGrey.withOpacity(0.5))],
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.card_giftcard_rounded,
            color: label != selectedCategory.name ? blue : white,
          ),
        ),
      ),
    );
  }
}
