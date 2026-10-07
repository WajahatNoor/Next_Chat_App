import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseChat {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final conversationCollectionName = 'conversations';
  final messageCollectionName = 'messages';

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    debugPrint("send trigger");
    await _firebaseFirestore
        .collection(conversationCollectionName)
        .doc(conversationId)
        .collection(messageCollectionName)
        .add({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  String getConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();

    return '${ids[0]}_${ids[1]}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream({
    required String conversationId,
  }) {
    return _firebaseFirestore
        .collection(conversationCollectionName)
        .doc(conversationId)
        .collection(messageCollectionName)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
