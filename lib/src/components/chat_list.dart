import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';

class ChatMessageWidget extends StatefulWidget {
  final Message message;
  final Message nextMessage;
  final int index;
  ChatMessageWidget(this.message, this.nextMessage, this.index)
      : super(key: Key(index.toString()));

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  Color indigo;
  bool preceding = false;

  @override
  void initState() {
    super.initState();
    indigo = Colors.indigoAccent[400];
    if (widget.nextMessage != null) {
      preceding = widget.message.author == widget.nextMessage.author;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: widget.message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: widget.message.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              chatMessageDecoration(),
              preceding ? SizedBox.shrink() : time(),
            ],
          ),
        ],
      ),
    );
  }

  Widget chatMessageDecoration() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0.8),
      decoration: BoxDecoration(
        color: Colors.indigoAccent[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.message.message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget time() {
    var date = widget.message.date;
    String time = "${date.hour}:${date.minute}";

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 16,
        ),
        child: Text(
          time,
          style: TextStyle(fontSize: 8),
        ),
      ),
    );
  }
}
