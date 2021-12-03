import 'package:flutter/material.dart';
import 'package:vpay/src/models/category.dart';

class AddToCart extends StatefulWidget {
  final Product product;

  const AddToCart({Key? key, required this.product}) : super(key: key);
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            // shrinkWrap: true,
            children: <Widget>[
              top(),
              Divider(height: 30),
              SizedBox(
                  // height: 500,
                  // child: Container(color: Colors.green),
                  ),
              bottom()
            ],
          ),
        ),
      ),
    );
  }

  Widget top() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 15, bottom: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // color: Colors.grey,
            height: 100,
            width: 100,
            child: Image.asset(
              'assets/bag.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 100,
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            // color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.name,
                  style: TextStyle(
                      color: Color(0xAA253535),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.5),
                ),
                SizedBox(height: 4),
                Text(
                  "GHS ${widget.product.price}",
                  style: TextStyle(
                      color: Color(0xe0252930),
                      fontWeight: FontWeight.w600,
                      fontSize: 15.5,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottom() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            'select size'.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).accentColor.withRed(10).withGreen(120),
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 1.2),
          )
        ],
      ),
    );
  }
}
