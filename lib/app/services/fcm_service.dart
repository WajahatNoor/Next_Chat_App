import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:next_chat/app/services/fcm_device_token_service.dart';
import 'local_notification_service.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _activeConversationId;

  // Initialize FCM and register message listeners.
  Future<void> initFCM() async {
    await requestPermission();
    final token = await getDeviceToken();

    // App is open and a push message arrives.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // User taps a push notification while app is in background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // User opens the app by tapping a notification
    // that launched it from a terminated state.
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _messaging.onTokenRefresh.listen((token) {
      FcmTokenService.instance.registerToken(token);
    });
  }

  Future<String?> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        debugPrint('APNs token available: ${apnsToken != null}');
      }

      final deviceToken = await _messaging.getToken();

      debugPrint('FCM token: $deviceToken');
      return deviceToken;
    } catch (e, stackTrace) {
      debugPrint('Failed to get FCM token: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  // Request notification permission.
  Future<void> requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Authorized");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("Authorized Provisionaly");
    } else {
      debugPrint("Not Authorized");
    }
  }

  // Handle messages received while the app is open.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint("FOREGROUND RECEVIED FCM");
    final conversationId = message.data['conversationId'];
    final senderId = message.data['senderId'];

    // Don't show a notification for the conversation
    // the user is already viewing.
    if (conversationId != null && conversationId == _activeConversationId) {
      return;
    }

    final notification = message.notification;

    await LocalNotificationService.instance.showMessageNotification(
      title: notification?.title ?? 'New message',
      body: notification?.body ?? 'You received a message',
      conversationId: conversationId ?? '',
      senderId: senderId ?? '',
    );
  }

  // Handle notification taps.
  void _handleNotificationTap(RemoteMessage message) {
    final conversationId = message.data['conversationId'];
    final senderId = message.data['senderId'];

    // We'll connect this to GoRouter navigation next.
    print('Notification tapped: $conversationId, $senderId');
  }

  // Set the conversation currently open in the UI.
  void setActiveConversation(String conversationId) {
    _activeConversationId = conversationId;
  }

  // Clear when leaving a conversation.
  void clearActiveConversation() {
    _activeConversationId = null;
  }
}
