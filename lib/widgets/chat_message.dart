import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message, required this.isMe});
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(32),
                topRight: const Radius.circular(32),
                bottomLeft: isMe
                    ? const Radius.circular(32)
                    : const Radius.circular(0),
                bottomRight: isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(32),
              ),
              color: isMe ? Colors.lightBlue[400]! : Colors.grey[300],
            ),
            child: Column(
              children: [
                if (!isMe)
                  Text(
                    getUsernameFromEmail(message.email),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                Text(
                  message.text,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getUsernameFromEmail(String email) {
    return email.split('@').first;
  }
}
