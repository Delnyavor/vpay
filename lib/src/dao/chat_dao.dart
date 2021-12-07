import 'package:firebase_database/firebase_database.dart';

class ChatDao {
  final messageRootRef =
      FirebaseDatabase.instance.reference().child("messages");
  final itemChatRef =
      FirebaseDatabase.instance.reference().child("chat_details");

  Future<String> createChatRoom(String vendorId, String userId) async {
    DatabaseReference chatRoomRef = messageRootRef.push();
    await chatRoomRef.set({
      'vendor': vendorId,
      'buyer': userId,
    });

    return chatRoomRef.key;
  }

  Future<bool> createItemChatDetails(String itemId) async {
    DatabaseReference itemsRef = itemChatRef.push();

    return true;
  }
}
