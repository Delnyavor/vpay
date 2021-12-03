import 'package:firebase_database/firebase_database.dart';

class ChatDao {
  final messageRootRef =
      FirebaseDatabase.instance.reference().child('messages');

  Future<void> createChatRoom(String vendorId, String userId) async {
    DatabaseReference chatRoomRef = messageRootRef.push();
    await chatRoomRef.set({
      'vendor': vendorId,
      'buyer': userId,
    });
  }
}
