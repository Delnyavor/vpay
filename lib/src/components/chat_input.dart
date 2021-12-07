import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';
import 'package:vpay/src/provider/chat_provider.dart';

class ChatInput extends StatefulWidget {
  final Function onSubmitted;
  ChatInput({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  TextEditingController controller = TextEditingController();
  late ChatProvider chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatProvider = ChatProvider().getChatProvider(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 5, 6, 5),
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
        color: Theme.of(context).colorScheme.primary,
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
    if (controller.text.isNotEmpty) {
      chatProvider.addMessage(
        Message(
          message: controller.text,
          isMe: true,
          author: 'me',
          date: DateTime.now(),
        ),
      );
      widget.onSubmitted();
    }
  }
}
