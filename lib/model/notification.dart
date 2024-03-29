import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:covid_tracker_app/model/database.dart';
import 'package:covid_tracker_app/model/location_model.dart';
import 'package:covid_tracker_app/model/push_notification.dart';
import 'package:covid_tracker_app/server_key.dart';
import 'package:covid_tracker_app/service_key.dart';
import 'package:dio/dio.dart';
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
  );

// Local notifications channel with low pitch 1 sec notify to represent issues notifications
  static const AndroidNotificationChannel localChannel =
      AndroidNotificationChannel(
    'medium_importance_channel', // id
    'Medium Importance Notifications', // title
    importance: Importance.high,
  );

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

  static void _firebaseMessagingForegroundMessageHandler(
      RemoteMessage message) {
    print("Foreground message recieved");

    log("_firebaseMessagingForegroundMessageHandler(RemoteMessage) called");

    log("RemoteMessage: ${message.toString()} ${message.notification.toString()} ${message.notification?.title}, ${message.notification?.body}, ${message.data}");

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
            pushChannel.id,
            pushChannel.name,
            channelDescription: pushChannel.description,
            icon: android!.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            // sound: 'notify30sec.aiff',
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
          ),
        ));

    try {
      saveLocations(message);
    } catch (e) {
      log("error while saving data: $e");
    }
  }

  static Future<void> saveLocations(RemoteMessage message) async {
    final LocationDatabaseProvider service = LocationDatabaseProvider();
    await service.open("location3_db.db");

    final LocationsFromPushNotification notificationsFromPush =
        LocationsFromPushNotification.fromJson(
            jsonDecode(message.data.toString()));

    String locations = "";

    for (final notif in (notificationsFromPush.locations ?? <Location>[])) {
      locations += "${notif.title}, ";
    }

    locations = locations.replaceRange(locations.length - 2, null, "");

    final userNotifications = UserNotification(
        "Someone has covid symptoms near you",
        "They visited the following locations: $locations");

    log("user: ${userNotifications.toMap()}");
    service.insertNotification(userNotifications);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    log("_firebaseMessagingBackgroundHandler(RemoteMessage) called");

    log("RemoteMessage: ${message.toString()} ${message.notification.toString()} ${message.notification?.title}, ${message.notification?.body}, ${message.data}");

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
          pushChannel.id,
          pushChannel.name,
          channelDescription: pushChannel.description,
          icon: android!.smallIcon,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          // sound: 'notify30sec.aiff',
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        ),
      ),
    );

    try {
      saveLocations(message);
    } catch (e) {
      log("error while saving data: $e");
    }
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

  Future<Map<String, dynamic>> sendNotification() async {
    try {
      final locationProvider = LocationDatabaseProvider();
      await locationProvider.open("location3_db.db");
      final locations = await locationProvider.getLocations();

      // locations.removeWhere((element) =>
      //     DateTime.parse(element.visitedLocationTile ??
      //             DateTime.now().microsecondsSinceEpoch.toString())
      //         .difference(DateTime.now())
      //         .inDays <
      //     14);

      final data = await sendNotificationToSubscribedTopic(locations);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  final Dio dio = Dio();

  Future<Map<String, dynamic>> sendNotificationToSubscribedTopic(
      List<Location> locations) async {
    try {
      final Response response = await dio.post(
        "https://fcm.googleapis.com/fcm/send",
        data: notificationData(locations),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "key=$serverKey",
          },
        ),
      );

      log(" response.data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw 'Sorry, an eror occurred!';
      }
    } catch (e) {
      log("error: ${e.toString()}");
      throw e.toString();
    }
  }

  Map<String, dynamic> notificationData(List<Location> locations) => {
        'notification': <String, dynamic>{
          'body': 'You may have been exposed to an infected person',
          'title': 'COVID-19 Exposure Alert',
        },
        'priority': 'high',
        // 'to':
        //     'c6yOSbQipEKuoC2TFD3dJS:APA91bHXTXXcEp5E6gZlyKSVaaNQsX9PeeCRvMx9eNy4Sxzke-TeYBcYluetNoV-kHpgtFgI8I1abKjDSB-FyB3esIehDiy0D8a6_V35HKBIkV2C2TqgQA3Mpv4bLW9t-7yQi-y8Uham'
        'data': <String, dynamic>{
          "\"locations\"": locations.map((e) => e.toMap()).toList(),
        },
        "to": "/topics/covidexposure"
      };
}
