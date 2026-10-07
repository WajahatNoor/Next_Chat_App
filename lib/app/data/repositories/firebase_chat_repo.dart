import 'package:flutter/material.dart';
import 'package:next_chat/app/data/models/message_model.dart';
import 'package:next_chat/app/services/firebase_chat.dart';

class FirebaseChatRepo {
  final FirebaseChat firebaseChat;
  FirebaseChatRepo({required this.firebaseChat});

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    debugPrint("MY ID: $senderId");
    debugPrint("OTHER ID: $receiverId");
    debugPrint("CONVERSATION ID: $conversationId");
    return firebaseChat.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  Stream<List<MessageModel>> getMessages({required String conversationId}) {
    return firebaseChat
        .messagesStream(conversationId: conversationId)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList(),
        );
  }
}
