import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static final String id = 'ChatScreen';
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: .center,
                children: [
                  Image.asset(kLogo, height: 30, width: 30),
                  const Text(
                    ' EasyChat',
                    style: TextStyle(
                      fontFamily: 'ShadowsIntoLight',
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),

            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return ChatMessage(
                        message: messagesList[index],
                        isMe: messagesList[index].email == currentUserEmail,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      messages.add({
                        kMessage: value,
                        kCreatedAt: DateTime.now(),
                        kSenderEmail: currentUserEmail,
                      });
                      controller.clear();
                      scrollController.jumpTo(
                        scrollController.position.minScrollExtent,
                      );
                    },
                    decoration: InputDecoration(
                      hint: const Text('Type a message...'),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Colors.lightBlue[300]),
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;

                          messages.add({
                            kMessage: text,
                            kCreatedAt: DateTime.now(),
                            kSenderEmail: currentUserEmail,
                          });

                          controller.clear();

                          scrollController.jumpTo(
                            scrollController.position.minScrollExtent,
                          );
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: .circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(body: Center(child: Text('Loading..')));
        }
      },
    );
  }
}
