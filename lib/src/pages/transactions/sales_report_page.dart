import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/widgets/slivers.dart';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  TextTheme theme;
  DateTime time = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context).textTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            header(),
            SliverPadding(
              padding: const EdgeInsets.all(15.0),
              sliver: SliverHeader(
                child: Center(
                    child: Text('GHC 255.70',
                        style: theme.headline4.copyWith(fontSize: 28))),
              ),
            ),
            options(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('$index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return SliverHeader(
      minHeight: 70,
      maxHeight: 70,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {},
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Balance',
                  style: theme.subtitle1,
                ),
                Text(
                  " ${time.weekday}, ${time.month}, ${time.day} ${time.year} ",
                  style: theme.overline,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget options() {
    return SliverHeader(
      minHeight: 130,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(3, -5),
                spreadRadius: -5,
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(3, 5),
                spreadRadius: -5,
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 10),
                spreadRadius: -5,
                blurRadius: 15,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.grey[200], shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.download,
                            size: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Withdraw Balance',
                        style: theme.caption,
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                ),
                InkWell(
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.grey[200], shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.piggyBank,
                            size: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Manage Bank Account',
                        style: theme.caption,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
