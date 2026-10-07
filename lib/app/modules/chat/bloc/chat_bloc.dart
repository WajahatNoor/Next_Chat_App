import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:next_chat/app/data/models/message_model.dart';
import 'package:next_chat/app/data/repositories/firebase_chat_repo.dart';
import 'package:next_chat/app/services/firebase_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseChatRepo firebaseChatRepo;
  final FirebaseChat firebaseChat;
  ChatBloc({required this.firebaseChatRepo, required this.firebaseChat})
    : super(ChatInitial()) {
    on<LoadedMessagesEvent>(loadedMessagesEvent);
    on<SendMessageEvent>(sendMessageEvent);
  }

  FutureOr<void> loadedMessagesEvent(
    LoadedMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      await emit.forEach<List<MessageModel>>(
        firebaseChatRepo.getMessages(conversationId: event.conversationId),
        onData: (messages) {
          return ChatLoaded(messages: messages, isSending: false);
        },
      );
    } catch (e) {
      emit(ChatLoadingError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> sendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      emit(ChatLoaded(messages: currentState.messages, isSending: true));

      try {
        await firebaseChatRepo.sendMessage(
          conversationId: firebaseChat.getConversationId(
            event.senderId,
            event.receiverId,
          ),
          senderId: event.senderId,
          receiverId: event.receiverId,
          text: event.messageText,
        );
      } catch (e) {
        emit(ChatLoaded(messages: currentState.messages, isSending: false));
        emit(SendingMessageError(errorMessage: e.toString()));
      }
    }
  }
}
