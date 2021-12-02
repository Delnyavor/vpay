class Message {
  String message;
  DateTime date;
  String author;
  bool isMe = false;
  MessagePosition messagePosition;

  Message(
      {this.date,
      this.message,
      this.author,
      this.isMe,
      this.messagePosition = MessagePosition.leading});
}

enum MessagePosition { leading, middle, trailing }
