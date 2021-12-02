import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/models/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> messages = [
    Message(message: 'hi', isMe: true, author: 'me', date: DateTime.now()),
    Message(
        message: 'Whats up', isMe: true, author: 'me', date: DateTime.now()),
    Message(
        message: 'Whats for dinner',
        isMe: true,
        author: 'me',
        date: DateTime.now()),
    Message(message: 'Ttyl', isMe: true, author: 'me', date: DateTime.now()),
    Message(message: 'hi', isMe: false, author: 'other', date: DateTime.now()),
    Message(
        message: 'Whats up',
        isMe: false,
        author: 'other',
        date: DateTime.now()),
    Message(
        message: 'Whats for dinner',
        isMe: false,
        author: 'other',
        date: DateTime.now()),
    Message(
        message: 'Ttyl', isMe: false, author: 'other', date: DateTime.now()),
  ];

  getChatProvider(BuildContext context) {
    return Provider.of<ChatProvider>(context);
  }

  addMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }
}
