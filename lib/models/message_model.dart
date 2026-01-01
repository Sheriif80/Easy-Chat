import 'package:chat_app/constants.dart';

class Message {
  final String text;
  final String email;

  Message({required this.text, required this.email});

  factory Message.fromJson(jsonData) {
    return Message(text: jsonData[kMessage], email: jsonData[kSenderEmail]);
  }
}
