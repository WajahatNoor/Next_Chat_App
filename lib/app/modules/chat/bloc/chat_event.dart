part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class LoadedMessagesEvent extends ChatEvent {
  final String conversationId;

  LoadedMessagesEvent({required this.conversationId});
}

class SendMessageEvent extends ChatEvent {
  final String messageText;
  final String senderId;
  final String receiverId;

  SendMessageEvent({
    required this.messageText,
    required this.senderId,
    required this.receiverId,
  });
}
