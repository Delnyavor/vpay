import 'package:flutter/material.dart';
import 'package:vpay/src/components/chat_input.dart';
import 'package:vpay/src/models/message.dart';
import 'package:vpay/src/components/chat_message.dart';
import 'package:vpay/src/provider/chat_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController scrollController = ScrollController();
  late ChatProvider chatProvider;
  List messages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatProvider = ChatProvider().getChatProvider(context);
    messages = chatProvider.messages;
  }

  ChatMessageWidget getCMWidget(int index) {
    if (index < messages.length - 1) {
      return ChatMessageWidget(
        messages[index],
        messages.length,
        messages[index + 1],
      );
    }
    return ChatMessageWidget(
      messages[index],
      messages.length,
      null,
    );
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
          ChatInput(onSubmitted: scrollDown),
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
