part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isSending;

  ChatLoaded({required this.messages, required this.isSending});
}

final class ChatLoadingError extends ChatState {
  final String errorMessage;

  ChatLoadingError({required this.errorMessage});
}

class SendingMessageError extends ChatState {
  final String errorMessage;

  SendingMessageError({required this.errorMessage});
}
