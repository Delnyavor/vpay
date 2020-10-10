import 'package:flutter/material.dart';
import 'package:vpay/src/models/category.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  DetailsPage({this.product});
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [mainImage(), details(), variants()],
      ),
    );
  }

  Widget mainImage() {
    return AspectRatio(
      aspectRatio: 1.2,
    );
  }

  Widget details() {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  Widget variants() {
    return Container(
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
    );
  }

  Widget addToCart() {
    return Center(
      child: FlatButton(
        child: Text('Add To Cart'),
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: null,
      ),
    );
  }
}
