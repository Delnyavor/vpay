import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final Widget newRoute;

  SearchWidget({Key? key, required this.newRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        // padding: const EdgeInsets.only(left: 20, right: 16),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Color(0x3fafbbf1),
          // ),
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Color(0x1fafbbd1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 8),
            ),
            // BoxShadow(
            //   color: Color(0x1fafbbc1),
            //   blurRadius: 1,
            //   spreadRadius: 0,
            //   offset: Offset(0, 3),
            // ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
          //   child: Icon(
          //     FontAwesomeIcons.search,
          //     size: 12,
          //   ),
          // ),
          Center(
            child: Text(
              'Search for a product',
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(letterSpacing: 0.5, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
