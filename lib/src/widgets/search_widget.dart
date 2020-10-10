import 'package:flutter/material.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final Widget newRoute;

  SearchWidget({Key key, this.newRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alt(context);
  }

  Widget prim(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 16, top: 13),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Hero(
              tag: 'SearchBar',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 2),
                      spreadRadius: -0.5,
                      blurRadius: 1,
                    ),
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.1),
                    //   offset: Offset(0, 3),
                    //   spreadRadius: 0,
                    //   blurRadius: 2,
                    // ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: ResponsiveSize.flexWidth(
                        20, MediaQuery.of(context).size.width),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Search',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(letterSpacing: 0.5, color: Colors.black45),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          searchToggle(context),
        ],
      ),
    );
  }

  Widget searchToggle(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'search',
      elevation: 4,
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(Icons.search, color: Colors.white),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => newRoute));
        // setState(() {
        //   searchState = !searchState;
        //   controller.clear();
        // });
        // Provider.of<InventoryProvider>(context).searchValue = "";
        // Provider.of<InventoryProvider>(context).toggleSearch();
      },
    );
  }

  Widget alt(context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 16, top: 13),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueGrey[50]),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                child: Icon(
                  Icons.search,
                  size: 20,
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
        ),
      ),
    );
  }
}
