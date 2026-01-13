import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static final String id = 'ChatScreen';

  final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Message> messagesList = [];

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontFamily: 'ShadowsIntoLight', fontSize: 30),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSucess) {
                  messagesList = state.messagesList;
                }
              },
              builder: (context, state) {
                return ListView.builder(
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                BlocProvider.of<ChatCubit>(
                  context,
                ).sendMessage(message: value, senderEmail: currentUserEmail);
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
                    BlocProvider.of<ChatCubit>(
                      context,
                    ).sendMessage(message: text, senderEmail: currentUserEmail);

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
  }
}
