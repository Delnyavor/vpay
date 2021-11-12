import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';
import 'package:vpay/src/widgets/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatList(
        messages: [
          Message(
              message: 'hi', isMe: true, author: 'me', date: DateTime.now()),
          Message(
              message: 'Whats up',
              isMe: true,
              author: 'me',
              date: DateTime.now()),
          Message(
              message: 'Whats for dinner',
              isMe: true,
              author: 'me',
              date: DateTime.now()),
          Message(
              message: 'Ttyl', isMe: true, author: 'me', date: DateTime.now()),
          Message(
              message: 'hi',
              isMe: false,
              author: 'other',
              date: DateTime.now()),
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
              message: 'Ttyl',
              isMe: false,
              author: 'other',
              date: DateTime.now()),
        ],
      ),
    );
  }
}
