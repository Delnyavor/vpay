import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/pages/home/search_page.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final Widget newRoute;

  SearchWidget({Key key, this.newRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(left: 20, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[50].withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.blueGrey[50].withOpacity(1),
              blurRadius: 1,
              spreadRadius: 0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: searchBar(context),
      ),
    );
  }

  Widget searchBar(context) {
    return Hero(
      tag: 'search',
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
            child: Icon(
              FontAwesomeIcons.search,
              size: 12,
            ),
          ),
          Text(
            'Search for a product',
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(letterSpacing: 0.5, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
