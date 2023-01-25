import 'dart:developer';
import 'dart:io';

import 'package:covid_tracker_app/model/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Push notifications channel with 30 sec normal notify sound
  static const AndroidNotificationChannel pushChannel =
      AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('notify30secc'));

// Local notifications channel with low pitch 1 sec notify to represent issues notifications
  static const AndroidNotificationChannel localChannel =
      AndroidNotificationChannel(
          'medium_importance_channel', // id
          'Medium Importance Notifications', // title
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('notify_low_pitch'));

  static Future<void> requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log("Permission result: ${settings.toString()}");
  }

  void startForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        final PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'] as String?,
          dataBody: message.data['body'] as String?,
        );
        final AndroidNotification? android = message.notification?.android;
        flutterLocalNotificationsPlugin.show(
            // showing notifications in background
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  pushChannel.id, pushChannel.name,
                  channelDescription: pushChannel.description,
                  icon: android!.smallIcon,
                  importance: Importance.max,
                  priority: Priority.high,
                  sound: const RawResourceAndroidNotificationSound(
                      'notify30secc')),
              iOS: const DarwinNotificationDetails(
                  // sound: 'notify30sec.aiff',
                  sound: 'notify30sec.aiff',
                  presentSound: true,
                  presentBadge: true,
                  presentAlert: true),
            ));
      }
    });
  }

  static Future<void> firebaseMain() async {
    await Firebase.initializeApp();

    const initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((event) {
      _firebaseMessagingForegroundMessageHandler(event);
    });

    await requestNotificationPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pushChannel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(localChannel);

    fetchAndUpdatePushNotificationToken();

    FirebaseMessaging.instance.subscribeToTopic("covid-tracking");
  }

  static void _firebaseMessagingForegroundMessageHandler(RemoteMessage event) {}

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print("NOTIFICATION BACKGROUND");

    log("_firebaseMessagingBackgroundHandler(RemoteMessage) called");

    log("RemoteMessage: ${message.toString()} ${message.notification.toString()} ${message.notification?.title}, ${message.notification?.body}, ${message.data['title']}, ${message.data['body']}, ${message.data}");

    final PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'] as String?,
      dataBody: message.data['body'] as String?,
    );
    final AndroidNotification? android = message.notification?.android;
    flutterLocalNotificationsPlugin.show(
        // showing notifications in background
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(pushChannel.id, pushChannel.name,
              channelDescription: pushChannel.description,
              icon: android!.smallIcon,
              importance: Importance.max,
              priority: Priority.high,
              sound: const RawResourceAndroidNotificationSound('notify30secc')),
          iOS: const DarwinNotificationDetails(
              // sound: 'notify30sec.aiff',
              sound: 'notify30sec.aiff',
              presentSound: true,
              presentBadge: true,
              presentAlert: true),
        ));
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    return Future.value(0);
  }

  static Future<void> fetchAndUpdatePushNotificationToken() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final String? token = await messaging.getToken();
      log("TOKEN = $token");
      // Any time the token refreshes, store this in the database too.
      messaging.onTokenRefresh.listen((token) {
        log("TOKEN = $token");
      });
    } catch (e) {
      log("fetchAndUpdatePushNotificationToken() error: $e");
    }
  }
}
