import 'package:flutter/material.dart';
import 'package:vpay/src/models/message.dart';

class ChatMessageWidget extends StatefulWidget {
  final Message message;
  final Message? nextMessage;
  final int index;

  ChatMessageWidget(
    this.message,
    this.index,
    this.nextMessage,
  ) : super(key: Key(index.toString()));

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool preceding = false;
  Radius roundRadius = Radius.circular(16);
  Radius pointedRadius = Radius.circular(4);

  @override
  void initState() {
    super.initState();
    if (widget.nextMessage != null) {
      preceding = widget.message.author == widget.nextMessage!.author;
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 1),
      decoration: BoxDecoration(
        color: widget.message.isMe
            ? Theme.of(context).primaryColor
            : Color(0xfff0f1f6),
        borderRadius: BorderRadius.only(
          topLeft: widget.message.isMe ? roundRadius : pointedRadius,
          topRight: widget.message.isMe ? pointedRadius : roundRadius,
          bottomRight: roundRadius,
          bottomLeft: roundRadius,
        ),
      ),
      child: Text(
        widget.message.message,
        style: TextStyle(
          color: widget.message.isMe ? Colors.white : Colors.black87,
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
