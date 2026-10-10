import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const channelId = 'chat_messages';
  static const channelName = 'Chat Messages';

  //initialize method for local notification
  Future<void> init() async {
    //define android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //define ios settings
    const iosSettings = DarwinInitializationSettings();

    //initialize both settings for platform
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    //initialize the plugin of local notificaiotn
    await plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    //define and create android notification channel
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: "Notification for new chat messages",
      importance: Importance.high,
    );
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(channel);
  }

  //On Notification interaction method
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) return;

    // We'll connect this payload to GoRouter in Step 9.
  }

  // //request permission of local notification method
  // Future<void> requestPermission() async {
  //   //android permission request
  //   final android = plugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >();

  //   await android?.requestNotificationsPermission();

  //   //ios permission request
  //   final ios = plugin
  //       .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin
  //       >();

  //   await ios?.requestPermissions(alert: true, badge: true, sound: true);
  // }

  Future<void> showMessageNotification({
    required String title,
    required String body,
    required String conversationId,
    required String senderId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await plugin.show(
      id: conversationId.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: '$conversationId|$senderId',
    );
  }
}
