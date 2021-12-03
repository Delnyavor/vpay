import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vpay/src/components/chart.dart';
import 'package:vpay/src/components/recent_activity_widget.dart';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage>
    with TickerProviderStateMixin {
  late TextTheme textTheme;
  late ThemeData theme;
  late TabController tabController;
  List<String> periods = ['1D', '1W', '1M', '3M', '6M', '1Y'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textTheme = Theme.of(context).textTheme;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            topBar(),
            percs(),
            periodBar(),
            revenue(),
            Chart(),
            LastActivitiesWidget()
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget percs() {
    return AspectRatio(
      aspectRatio: 2.15,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        // color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            percsWidget(Color(0xf00080F6), 'GHC 1,234.56', 'Product In'),
            percsWidget(Color(0xdd00A0EF), 'GHC 1,234.56', 'Product Out'),
          ],
        ),
      ),
    );
  }

  Widget percsWidget(Color color, String amount, String type) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: PhysicalModel(
        // color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.black54,
        color: color,
        elevation: 20,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
            // border: Border.all(color: color, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: type.toLowerCase().contains('out') ? pi : 0,
                  child: Image.asset(
                    'assets/pie-chart.png',
                    height: 20,
                  ),
                ),
                Text(
                  amount,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, letterSpacing: 1),
                ),
                Text(
                  type,
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget revenue() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue',
            style: TextStyle(
                letterSpacing: 1,
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'GHC 27,003.98',
            style: textTheme.headline5,
          )
        ],
      ),
    );
  }

  Widget periodBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TabBar(
        labelStyle: textTheme.caption!
            .copyWith(letterSpacing: 0.5, fontWeight: FontWeight.w500),
        controller: tabController,
        labelColor: Color(0xf00080F6),
        isScrollable: true,
        unselectedLabelColor: Colors.black45,
        indicatorSize: TabBarIndicatorSize.label,
        onTap: (index) {},
        tabs: [
          for (final period in periods)
            Tab(
              text: period,
            )
        ],
      ),
    );
  }
}

class PeriodBar extends StatefulWidget {
  @override
  _PeriodBarState createState() => _PeriodBarState();
}

class _PeriodBarState extends State<PeriodBar> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
    );
  }
}
