import 'package:flutter/material.dart';

class LastActivitiesWidget extends StatefulWidget {
  @override
  _LastActivitiesWidgetState createState() => _LastActivitiesWidgetState();
}

class _LastActivitiesWidgetState extends State<LastActivitiesWidget> {
  late TextTheme textTheme;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    textTheme = Theme.of(context).textTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          buildChildren(),
          Center(
            child: FlatButton(
                child: Text(
                  'See all',
                  style: TextStyle(
                      color: Color(0xf00080F6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget buildChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        activities('Eli', 'added to inventory', '2 minutes ago'),
        SizedBox(height: 5),
        activities('Eli', 'added to inventory', '2 minutes ago'),
        SizedBox(height: 5),
        activities('Eli', 'added to inventory', '2 minutes ago'),
        SizedBox(height: 5),
        activities('Eli', 'added to inventory', '2 minutes ago'),
      ],
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
      child: Text(
        'Last Activities',
        style: textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5),
      ),
    );
  }

  Widget activities(String who, String what, String when) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xdd00b0EF),
      ),
      title: Text(
        '$who $what',
        maxLines: 2,
        style: textTheme.subtitle2!.copyWith(color: Colors.black87),
      ),
      subtitle: Text(
        '$when',
        style: textTheme.subtitle2!.copyWith(color: Colors.black45),
      ),
    );
  }
}

class StockAlertWidget extends StatefulWidget {
  @override
  _StockAlertWidgetState createState() => _StockAlertWidgetState();
}

class _StockAlertWidgetState extends State<StockAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 20,
      borderRadius: BorderRadius.circular(15),
      shadowColor: Colors.black54,
      child: AspectRatio(
        aspectRatio: 2.5,
      ),
    );
  }
}
