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
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
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
          BackLayer(),
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
            parent: widget.animationController, curve: Curves.easeOut));

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.82, 0))
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.easeInOut));

    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInOut));

    rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0.4, 1, curve: Curves.linear)));
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
    return AnimatedBuilder(
      animation: radiusAnimation,
      builder: (context, builderChild) => SlideTransition(
        position: offsetAnimation,
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
      child: frontLayerContents(),
    );
  }

  Scaffold frontLayerContents() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Center(
          child: Text(
            'Vpay',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        primary: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: RotationTransition(
          turns: rotationAnimation,
          child: IconButton(
            onPressed: () {
              if (widget.animationController.isCompleted)
                widget.animationController.reverse();
              else
                widget.animationController.forward();
            },
            icon: Icon(Icons.sort),
          ),
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
  @override
  _BackLayerState createState() => _BackLayerState();
}

class _BackLayerState extends State<BackLayer> {
  TextStyle theme;
  ScrollController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white);
    controller = ScrollController();
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
      ListTile(
        leading: Icon(
          FontAwesomeIcons.creditCard,
          size: 18,
          color: Colors.white,
        ),
        title: Text('Enter Promo Code', style: theme),
      ),
      ListTile(
        leading: Icon(
          Icons.settings,
          size: 18,
          color: Colors.white,
        ),
        title: Text('Settings', style: theme),
      ),
      ListTile(
        leading: Icon(
          FontAwesomeIcons.outdent,
          size: 18,
          color: Colors.white,
        ),
        title: Text('Logout', style: theme),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white12),
      child: CustomScrollView(
        anchor: 0.4,
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(children()),
            ),
          )
        ],
      ),
    );
  }
}
