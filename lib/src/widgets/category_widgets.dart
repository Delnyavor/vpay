import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/models/category.dart';
import 'package:provider/provider.dart';

import 'package:vpay/src/provider/products_provider.dart';

import 'modal.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;

  const CategoryWidget({Key key, this.category}) : super(key: key);
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  ProductsProvider provider;
  TextTheme textTheme;
  Category category = Category();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ProductsProvider>(context);

    textTheme = Theme.of(context).textTheme;
  }

  @override
  Widget build(BuildContext context) {
    print('building categories');

    Orientation orientation = MediaQuery.of(context).orientation;

    List<Product> products =
        this.provider.getProductsByCategory(widget.category.name);
    return products.isEmpty
        ? Center(
            child: Text('Nothing here yet'),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.5),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(
                product: products[index],
                index: index,
                textTheme: textTheme,
              );
            },
          );
  }
}

class ProductWidget extends StatelessWidget {
  final Product product;
  final int index;
  final TextTheme textTheme;
  const ProductWidget({this.product, this.textTheme, this.index});

  void showModal(context) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyModal(
          product: product,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      //  () {
      //   // showModal(context);
      // },
      child: contents(),
    );
  }

  Widget contents() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: shadows(),
              ),
              child: interactions(),
            ),
          ),
          descriptors(),
        ],
      ),
    );
  }

  List<BoxShadow> shadows() => [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          offset: Offset(5, 1),
          spreadRadius: -5,
          blurRadius: 5,
        ),
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          offset: Offset(1, 5),
          spreadRadius: -5,
          blurRadius: 5,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 5),
          spreadRadius: 0,
          blurRadius: 5,
        ),
      ];

  Widget interactions() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1 / 1.25,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image(),
            // actions(),
          ],
        ),
      ),
    );
  }

  Widget image() => index == null
      ? Colors.grey[400]
      : Padding(
          padding: const EdgeInsets.all(0.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/${(index % 4) + 1}.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

  Widget descriptors() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ideal Milk (Regular)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'GHS${product.price}',
                style: textTheme.overline.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Transform(
            origin: Offset(10, 0),
            transform: Matrix4.rotationY(pi),
            child: action(
                icon: Icons.add_shopping_cart,
                onTap: () {
                  print('shop');
                }),
          )
        ],
      );

  Widget actions() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
        child: Container(
          color: Colors.black38,
          child: SizedBox(
            height: 50,
            child: Row(
              // mainAxisSize: MainAxisSize.min
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                action(
                    icon: Icons.edit,
                    onTap: () {
                      print('edit');
                    }),
                action(
                    icon: Icons.add_shopping_cart,
                    onTap: () {
                      print('shop');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget action({IconData icon, void Function() onTap}) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Icon(
            icon,
            color: Colors.grey[800],
            size: 22,
          ),
        ),
      );

  void moveToView(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ProductPage(
    //               product: product,
    //             )));
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
      builder: (context) => MyModal(),
    );
  }
}
