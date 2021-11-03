import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vpay/src/models/category.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/pages/product%20details/details_page.dart';

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
  ThemeData theme;
  Category category = Category();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ProductsProvider>(context);

    textTheme = Theme.of(context).textTheme;
    theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
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
          mainAxisSpacing: 10,
          childAspectRatio: 0.74,
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
      {this.product, this.theme, this.textTheme, this.index, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('tapped');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            image(),
            descriptors(),
          ],
        ),
      ),
    );
  }

  Widget image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1 / 1.1,
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
    );
  }

  Widget descriptors() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Marlin Waterloom',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.78),
                fontSize: 12,
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'GHS${product.price}',
                    style: textTheme.overline.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Colors.black54,
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
        MaterialPageRoute(
            builder: (context) => DetailsPage(
                  product: product,
                )));
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

class Interactor extends StatefulWidget {
  final Product product;
  Interactor({this.product});
  @override
  _InteractorState createState() => _InteractorState();
}

class _InteractorState extends State<Interactor> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> slideAnimation, scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    slideAnimation = Tween<double>(begin: 0, end: 0.2)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    scaleAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void showModal(context) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyModal(
          product: widget.product,
        );
      },
    );
  }

  void animate() {
    if (controller.isCompleted) {
      controller.reverse();
    } else
      controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        animate();
      },
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) => Opacity(
          opacity: scaleAnimation.value,
          child: SizedBox.expand(
            child: Container(
              color: Theme.of(context)
                  .accentColor
                  .withOpacity(scaleAnimation.value),
              child: ScaleTransition(
                scale: scaleAnimation,
                child: actions(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget actions() {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              // mainAxisSize: MainAxisSize.min
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                action(
                    icon: Icons.edit,
                    onTap: () {
                      print('edit');
                    }),
                SizedBox(
                  width: 15,
                ),
                Text('Edit', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              // mainAxisSize: MainAxisSize.min
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                action(
                    icon: Icons.add_shopping_cart,
                    onTap: () {
                      print('shop');
                    }),
                SizedBox(
                  width: 15,
                ),
                Text('Add', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget action({IconData icon, void Function() onTap}) => InkWell(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            iconSize: 20,
            onPressed: () {},
            icon: Icon(
              icon,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
          ),
        ),
      );
}
