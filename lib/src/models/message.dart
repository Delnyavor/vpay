class Message {
  String message;
  DateTime date;
  String author;
  bool isMe = false;

  Message({
    required this.date,
    required this.message,
    required this.author,
    required this.isMe,
  });
}
