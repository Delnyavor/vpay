import 'package:flutter/material.dart';
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';
import 'package:vpay/src/widgets/add_to_cart.dart';

class MyModal extends StatefulWidget {
  final Product product;

  const MyModal({Key key, this.product}) : super(key: key);
  @override
  _MyModalState createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> with TickerProviderStateMixin {
  bool second = false;
  double dpr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dpr = MediaQuery.of(context).devicePixelRatio;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: items(context));
  }

  Widget items(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: ResponsiveSize.flexSize(190, dpr),
      ),
      color: Colors.white,
      padding: EdgeInsets.only(top: 3),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              setState(() {
                second = true;
              });
            },
            leading: Padding(
              padding: const EdgeInsets.only(left: 4, top: 4.0),
              child: Icon(
                Icons.add_photo_alternate,
                size: 20,
              ),
            ),
            title: Text(
              "View Product",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                second = true;
              });
            },
            leading: Padding(
              padding: const EdgeInsets.only(left: 4, top: 4.0),
              child: Icon(
                Icons.edit,
                size: 20,
              ),
            ),
            title: Text(
              "Edit Product",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                elevation: 100,
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddToCart(product: widget.product,);
                },
              );
            },
            leading: Padding(
              padding: const EdgeInsets.only(left: 4, top: 4.0),
              child: Icon(
                Icons.shopping_cart,
                size: 20,
              ),
            ),
            title: Text(
              "Add to Cart",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Class1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 500, color: Colors.red);
  }
}

class Class2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 200, color: Colors.grey);
  }
}

class Class3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 200, color: Colors.green);
  }
}
