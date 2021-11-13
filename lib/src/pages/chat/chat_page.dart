import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';
import 'package:vpay/src/components/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

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
  Message getNextIndex(Message m) {
    int i = messages.indexOf(m);
    if (i < messages.length - 1) {
      return messages[i + 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: chatList(),
          ),
          inputfield()
        ],
      ),
    );
  }

  Widget chatList() {
    return ListView.builder(
      controller: scrollController,
      // reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (index < messages.length - 1) {
          return ChatMessageWidget(
            messages[index],
            messages[index + 1],
            messages.length,
          );
        }
        return ChatMessageWidget(
          messages[index],
          null,
          messages.length,
        );
      },
    );
  }

  Widget inputfield() {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      // height: 60,
      child: Row(
        children: [
          Flexible(
            child: textField(),
          ),
          SizedBox(width: 4),
          submitIcon(),
        ],
      ),
    );
  }

  Widget textField() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget submitIcon() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.indigoAccent[400],
        // borderRadius: BorderRadius.circular(50),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: submit,
        icon: Icon(
          Icons.send,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  void submit() {
    print("Before:" + scrollController.position.maxScrollExtent.toString());
    if (controller.text.isNotEmpty) {
      messages.add(
        Message(
          message: controller.text,
          isMe: true,
          author: 'me',
          date: DateTime.now(),
        ),
      );
      setState(() {});
      scrollDown();
    }
  }

  void scrollDown() {
    Future.delayed(Duration(milliseconds: 10), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      print("After: " + scrollController.position.maxScrollExtent.toString());
    });
  }
}
