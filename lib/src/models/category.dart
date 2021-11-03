import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String id;
  final DocumentReference reference;

  Category({this.id, this.name, this.reference});

  Category.fromMap(Map<String, dynamic> map, {this.id, this.reference})
      : name = map['name'];

  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), id: snapshot.id);

  toJson() {
    return {"name": name};
  }
}

class Product {
  String id;
  String name;
  String description;
  double quantity;
  double price;
  String img;
  String category;
  // List<Variation> variations;
  DocumentReference reference;

  Product({
    this.name = "",
    this.price = 0,
    this.img = "",
    this.quantity = 0,
    this.description = "",
    this.id = "",
    this.category = "",
    // this.variations
  });

  Product.fromMap(Map<String, dynamic> map, {this.id, this.reference})
      : name = map['name'].toString(),
        description = map['description'],
        quantity = map['quantity'],
        price = map['price'],
        img = map['img'],
        category = map['category'].toString();
  // variations = List.from(map['variations'])

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(),
            id: snapshot.id, reference: snapshot.reference);

  toJson() {
    return {
      "price": price,
      "name": name,
      "img": img,
      "quantity": quantity,
      "category": category,
      "description": description
      // "variations": variations
    };
  }
}

class CartModel {
  final Product product;
  double quantity;
  double _cost;

  CartModel({this.product, this.quantity})
      //TODO product price is required
      //also, this works
      : _cost = quantity * (product.price ?? 0);

  double get cost => _cost;

  void recalculateCost() {
    _cost = quantity * product.price;
  }
}
