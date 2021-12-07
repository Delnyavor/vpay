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
  FrontLayer({Key? key, required this.animationController}) : super(key: key);
  @override
  _FrontLayerState createState() => _FrontLayerState();
}

class _FrontLayerState extends State<FrontLayer> with TickerProviderStateMixin {
  late ThemeData theme;
  late ScrollController controller;
  late TabController tabController;
  late double deviceWidth;
  late ProductsProvider provider;
  List<Category> categories = [];
  Category selectedCategory = Category(name: "", id: '0');

  bool completed = false;
  late Animation<Offset> offsetAnimation;
  late Animation<BorderRadius> radiusAnimation;
  late Animation<double> scaleAnimation, rotationAnimation;

  late Size dimensions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dimensions = MediaQuery.of(context).size;
    theme = Theme.of(context);
    deviceWidth = MediaQuery.of(context).size.width;

    provider = Provider.of<ProductsProvider>(context);
    categories = provider.categories;
    initialiseTabController();

    radiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(20))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.85))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    scaleAnimation = Tween<double>(begin: 1, end: 0.85).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInOut));

    rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 1, curve: Curves.easeIn)));
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    tabController = TabController(vsync: this, length: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  void initialiseTabController() {
    int index = 0;

    if (categories.isNotEmpty) {
      if (selectedCategory.name.isEmpty) {
        selectedCategory = categories[0];
      } else {
        index = categories.indexOf(selectedCategory);
      }
    }

    tabController = TabController(
        vsync: this, length: categories.length, initialIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    return animatedBuilder(child: frontLayerContents());
  }

  Widget animatedBuilder({required Widget child}) {
    return AnimatedBuilder(
      animation: widget.animationController,
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
            minHeight: 45,
            maxHeight: 45,
            floating: true,
            child: SearchWidget(
              newRoute: Container(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          sliver: SliverHeader(
            minHeight: 20,
            maxHeight: 20,
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
          // highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
          ),
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          labelStyle: theme.textTheme.caption!.copyWith(
              letterSpacing: 0.2, fontWeight: FontWeight.w500, fontSize: 11),
          controller: tabController,
          labelColor: Colors.black,
          isScrollable: true,
          unselectedLabelColor: Colors.black38,
          unselectedLabelStyle: theme.textTheme.caption!.copyWith(
              letterSpacing: 0.2, fontWeight: FontWeight.w400, fontSize: 11),
          indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          // indicatorSize: TabBarIndicatorSize.tab,

          onTap: (index) {
            setState(() {
              selectedCategory = categories[index];
            });
          },
          tabs: [
            for (final category in categories)
              Tab(
                text: category.name,
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
}
