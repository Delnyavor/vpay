// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserData {
//   final String uid, uuid;
//   final String key;
//   DocumentReference reference;

//   UserData({this.uid, this.uuid, this.key});

//   UserData.fromMap(Map<String, dynamic> map, {this.reference})
//       : key = map['key'],
//         uuid = map['uuid'],
//         uid = map['uid'];

//   UserData.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data(), reference: snapshot.reference);

//   toJson() {
//     return {"uid": uid, "uuid": uuid, "key": key};
//   }
// }
