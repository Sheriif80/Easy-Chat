import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  void sendMessage({required String message, required String senderEmail}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        kSenderEmail: senderEmail,
      });
    } on Exception catch (e) {
      emit(ChatFailure());
    }
  }

  void loadMessages() {
    emit(ChatLoading());
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      final List<Message> messagesList = [];

      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }

      emit(ChatSucess(messagesList: messagesList));
    });
  }
}
