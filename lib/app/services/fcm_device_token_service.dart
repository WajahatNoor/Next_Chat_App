import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:next_chat/app/services/fcm_service.dart';

class FcmTokenService {
  FcmTokenService._();

  static final FcmTokenService instance = FcmTokenService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //registor new token per device per auth user
  Future<void> registerToken(String token) async {
    debugPrint("CALLED REGISTOR TOKEN :::");
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  //remove clean up the device token of device per user on logout
  Future<void> removeCurrentToken() async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      final token = await FcmService.instance.getDeviceToken();

      if (token == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
    } catch (e) {
      debugPrint('FCM token removal failed: $e');
    }
  }
}
