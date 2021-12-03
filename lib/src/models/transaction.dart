import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpay/src/models/category.dart';

class Transaction {
  final String id, transactionId, number;
  final double cost;
  final String paymentMode;
  final bool isRefunded;
  final DocumentReference reference;
  final DateTime? timestamp;

  Transaction(
      {required this.id,
      required this.number,
      required this.transactionId,
      required this.reference,
      required this.cost,
      required this.paymentMode})
      : isRefunded = false,
        timestamp = DateTime.now();

  Transaction.fromMap(Map<String, dynamic> map,
      {required this.reference, this.timestamp})
      : id = map['id'],
        number = map['number'],
        transactionId = map['transactionId'],
        isRefunded = map['isRefunded'],
        cost = map['cost'],
        paymentMode = map['paymentMode'];

  Transaction.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

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
  late final DocumentReference ref;
  final double total;
  final String productName;

  TransactionDetails({required this.total, required this.productName});

  TransactionDetails.fromMap(Map<String, dynamic> map, {required this.ref})
      : productName = map["productName"],
        total = map["total"];

  TransactionDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            ref: snapshot.reference);

  toJson() {
    return {
      "productName": productName,
      "total": total,
    };
  }
}
