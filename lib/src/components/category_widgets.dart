import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vpay/src/models/category.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/pages/product%20details/details_page.dart';

import 'package:vpay/src/provider/products_provider.dart';
import 'package:vpay/src/utils/route_transitions.dart';

import 'modal.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
    with AutomaticKeepAliveClientMixin {
  late ProductsProvider provider;
  late TextTheme textTheme;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ProductsProvider>(context);

    textTheme = Theme.of(context).textTheme;
    theme = Theme.of(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Product> products =
        this.provider.getProductsByCategory(widget.category.name);
    return products.isEmpty ? buildNoProducts() : buildContents(products);
  }

  Widget buildNoProducts() {
    return SliverGrid(
      delegate: SliverChildListDelegate([
        Center(
          child: Text('Nothing here yet'),
        ),
      ]),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
    );
  }

  Widget buildContents(List<Product> products) {
    final ThemeData theme = Theme.of(context);

    Orientation orientation = MediaQuery.of(context).orientation;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ProductWidget(
              focusNode: new FocusNode(),
              product: products[index],
              index: index,
              textTheme: textTheme,
              theme: theme,
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final Product product;
  final FocusNode focusNode;
  final int index;
  final TextTheme textTheme;
  final ThemeData theme;
  const ProductWidget(
      {required this.product,
      required this.theme,
      required this.textTheme,
      required this.index,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        viewProduct(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            image(),
            descriptors(),
          ],
        ),
      ),
    );
  }

  Widget image() {
    return Hero(
      tag: index.toString(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/${(index % 3) + 1}.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget descriptors() => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Marlin Waterloom in a place',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'GHS${product.price}',
                    style: textTheme.overline!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget action(IconData icon) => Builder(
        builder: (BuildContext context) => InkWell(
          onTap: () {
            viewProduct(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 25,
              width: 25,
              color: theme.accentColor.withOpacity(0.15),
              child: Icon(
                icon,
                color: theme.accentColor,
                size: 17,
              ),
            ),
          ),
        ),
      );

  void viewProduct(BuildContext context) {
    Navigator.push(
      context,
      fadeInRoute(
        DetailsPage(
          product: product,
        ),
      ),
    );
  }

  void moveToEdit(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => NewProductPage(
    //               product: product,
    //             )));
  }

  void addToCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => MyModal(
        product: this.product,
      ),
    );
  }
}
