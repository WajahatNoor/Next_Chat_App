import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime? createdAt;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.createdAt,
  });

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return MessageModel(
      senderId: data?['senderId'] ?? '',
      receiverId: data?['receiverId'] ?? '',
      text: data?['text'] ?? '',
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
