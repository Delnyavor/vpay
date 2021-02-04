import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/pages/home/search_page.dart';
import 'package:vpay/src/pages/transactions/sales_report_page.dart';
import 'package:vpay/src/provider/products_provider.dart';
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';
import 'package:vpay/src/widgets/category_widgets.dart';
import 'package:vpay/src/widgets/search_widget.dart';
import 'package:vpay/src/widgets/slivers.dart';

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
          FrontLayer(
            animationController: animationController,
          ),
          BackLayer(animationController),
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
    if (categories.isNotEmpty) selectedCategory = categories[0];

    tabController = TabController(vsync: this, length: categories.length);
    radiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(20))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.8))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.linear));

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.linear));

    rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
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
      if (widget.animationController.value == 0)
        setState(() {
          completed = false;
          print(completed);
        });
      else if (widget.animationController.value == 1)
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

  @override
  Widget build(BuildContext context) {
    return frontLayerContents();
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radiusAnimation.value,
                ),
                child: builderChild,
              ),
            ),
          ),
        ),
      ),
      child: child,
    );
  }

  Scaffold frontLayerContents() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Center(
          child: Text(
            'Vpay',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_left),
          ),
        ],
      ),
      body: SafeArea(
        child: IgnorePointer(ignoring: completed, child: scrollView()),
      ),
    );
  }

  NestedScrollView scrollView() {
    return NestedScrollView(
      controller: controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 5, top: 10),
          sliver: SliverHeader(
            floating: true,
            child: SearchWidget(newRoute: SearchPage()),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 30, bottom: 10, left: 3),
          sliver: SliverHeader(
            minHeight: ResponsiveSize.flexWidth(40, deviceWidth),
            maxHeight: ResponsiveSize.flexWidth(40, deviceWidth),
            child: tabBar(),
          ),
        ),
      ],
      body: CategoryWidget(
        category: selectedCategory,
      ),
    );
  }

  Widget tabBar() {
    return TabBar(
      labelStyle: theme.textTheme.caption
          .copyWith(letterSpacing: 0.5, fontWeight: FontWeight.w500),
      controller: tabController,
      labelColor: theme.accentColor,
      isScrollable: true,
      unselectedLabelColor: Colors.black45,
      indicatorSize: TabBarIndicatorSize.label,
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
    );
  }
}

class BackLayer extends StatefulWidget {
  final AnimationController controller;
  BackLayer(this.controller);
  @override
  _BackLayerState createState() => _BackLayerState();
}

class _BackLayerState extends State<BackLayer> {
  TextStyle theme;
  ScrollController controller;
  Animation slideAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white);
    controller = ScrollController();
    slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (BuildContext context, Widget child) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
      child: childStack(),
    );
  }

  Widget childStack() {
    return Stack(
      children: [
        gesturePane(),
        menuPane(),
      ],
    );
  }

  Widget menuPane() {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 6),
      decoration: BoxDecoration(color: Color(0xFF191919)),
      child: CustomScrollView(
        // reverse: true,
        anchor: 0.2,
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
            sliver: SliverList(
              delegate: SliverChildListDelegate(children()),
            ),
          )
        ],
      ),
    );
  }

  Widget gesturePane() {
    return GestureDetector(
      onTap: () {
        widget.controller.reverse();
      },
    );
  }

  List<Widget> children() {
    return [
      ListTile(
        leading: Icon(
          FontAwesomeIcons.ccAmazonPay,
          size: 18,
          color: Colors.white,
        ),
        title: Text('Transactions', style: theme),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SalesReportPage()));
        },
      ),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.creditCard,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Enter Promo Code', style: theme)),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            Icons.settings,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Settings', style: theme)),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.outdent,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Logout', style: theme)),
      SizedBox(height: 10),
      ListTile(
        leading: Icon(
          FontAwesomeIcons.ccAmazonPay,
          size: 18,
          color: Colors.white,
        ),
        title: Text('Transactions', style: theme),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SalesReportPage()));
        },
      ),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.creditCard,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Enter Promo Code', style: theme)),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            Icons.settings,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Settings', style: theme)),
      SizedBox(height: 10),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.outdent,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Logout', style: theme)),
    ];
  }
}
