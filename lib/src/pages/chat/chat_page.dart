import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';
import 'package:vpay/src/components/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  ChatMessageWidget getCMWidget(int index) {
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
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: backButton(),
        title: profile(),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chatList(),
          inputfield(),
        ],
      ),
    );
  }

  Widget backButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back, color: Colors.black),
    );
  }

  Widget profile() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        profileImage(),
        Text(
          'Joe Smith',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget profileImage() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
      ),
    );
  }

  Widget chatList() {
    return Flexible(
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsetsDirectional.only(top: 20),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return getCMWidget(index);
        },
      ),
    );
  }

  Widget inputfield() {
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 5, 6, 5),
      // height: 60,
      child: Row(
        children: [
          Flexible(
            child: textField(),
          ),
          submitButton(),
        ],
      ),
    );
  }

  Widget textField() {
    return PhysicalModel(
      color: Color(0xfff4f8fa),
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 12,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: attachmentButton(),
        ),
      ),
    );
  }

  Widget submitButton() {
    return IconButton(
      onPressed: submit,
      icon: Icon(
        Icons.send_outlined,
        size: 20,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget attachmentButton() {
    return IconButton(
      onPressed: null,
      icon: Transform.rotate(
        angle: pi * 0.2,
        child: Icon(
          Icons.attach_file,
          size: 20,
          color: Colors.blueGrey,
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
    Future.delayed(Duration(milliseconds: 5), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      print("After: " + scrollController.position.maxScrollExtent.toString());
    });
  }
}
