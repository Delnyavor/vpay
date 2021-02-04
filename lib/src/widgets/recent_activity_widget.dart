import 'package:flutter/material.dart';

class LastActivitiesWidget extends StatefulWidget {
  @override
  _LastActivitiesWidgetState createState() => _LastActivitiesWidgetState();
}

class _LastActivitiesWidgetState extends State<LastActivitiesWidget> {
  TextTheme textTheme;
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
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          buildChildren(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [activities('Eli', 'added to inventory', '2 minutes ago')],
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'Last Activities',
        style: textTheme.subtitle2
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget activities(String who, String what, String when) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xf00080F6),
      ),
      title: Text(
        '$who $what',
        maxLines: 2,
        style: textTheme.subtitle2
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
