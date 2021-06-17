import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpay/src/models/category.dart';

class Transaction {
  final String id, transactionId, number;
  final double cost;
  final String paymentMode;
  final bool isRefunded;
  final DocumentReference reference;
  final DateTime timestamp;

  Transaction(
      {this.id,
      this.number,
      this.transactionId,
      this.reference,
      this.cost,
      this.paymentMode})
      : isRefunded = false,
        timestamp = DateTime.now();

  Transaction.fromMap(Map<String, dynamic> map,
      {this.reference, this.timestamp})
      : id = map['id'],
        number = map['number'],
        transactionId = map['transactionId'],
        isRefunded = map['isRefunded'],
        cost = map['cost'],
        paymentMode = map['paymentMode'];

  Transaction.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      "id": id,
      "timestamp": timestamp,
      "transactionId": transactionId,
      "isRefunded": isRefunded,
      "cost": cost,
      "paymentMode": paymentMode,
      "number": number
    };
  }
}

class TransactionDetails {
  DocumentReference ref;
  CartModel model;
  final String productName;
  final double subTotal, quantity;
  TransactionDetails({this.model})
      : subTotal = model.cost,
        productName = model.product.name,
        quantity = model.quantity;

  TransactionDetails.fromMap(Map<String, dynamic> map, {this.ref})
      : productName = map["productName"],
        subTotal = map["subTotal"],
        quantity = map["quantity"];

  TransactionDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), ref: snapshot.reference);

  toJson() {
    return {
      "productName": productName,
      "subTotal": subTotal,
      "quantity": quantity,
    };
  }
}
