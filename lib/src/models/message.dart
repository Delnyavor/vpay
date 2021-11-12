class Message {
  String message;
  DateTime date;
  String author;
  bool isMe = false;

  Message({this.date, this.message, this.author, this.isMe});
}
