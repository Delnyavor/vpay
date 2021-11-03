import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/pages/transactions/sales_report_page.dart';

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
    theme = Theme.of(context)
        .textTheme
        .subtitle1
        .copyWith(color: Colors.white, fontSize: 12);
    controller = ScrollController();
    slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return menuPane();
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
      // SizedBox(height: 5),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.creditCard,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Enter Promo Code', style: theme)),
      // SizedBox(height: 5),
      ListTile(
          leading: Icon(
            Icons.settings,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Settings', style: theme)),
      // SizedBox(height: 5),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.outdent,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Logout', style: theme)),
      // SizedBox(height: 5),
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
      // SizedBox(height: 5),
      ListTile(
          leading: Icon(
            FontAwesomeIcons.creditCard,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Enter Promo Code', style: theme)),
      // SizedBox(height: 5),
      ListTile(
          leading: Icon(
            Icons.settings,
            size: 18,
            color: Colors.white,
          ),
          title: Text('Settings', style: theme)),
      // SizedBox(height: 5),
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
