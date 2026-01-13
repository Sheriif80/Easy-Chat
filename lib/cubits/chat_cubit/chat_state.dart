part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSucess extends ChatState {
  final List<Message> messagesList;
  ChatSucess({required this.messagesList});
}

final class ChatFailure extends ChatState {}
