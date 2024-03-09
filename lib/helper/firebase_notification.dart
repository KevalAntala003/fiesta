import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

ValueNotifier<String> notificationBody = ValueNotifier<String>('');

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('receiveNotification _firebaseMessagingBackgroundHandler data: ${message.data}');
}

class FireBaseNotification {
  static final FireBaseNotification _fireBaseNotification = FireBaseNotification.init();

  factory FireBaseNotification() {
    return _fireBaseNotification;
  }

  FireBaseNotification.init();

  late FirebaseMessaging firebaseMessaging;
  late AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final _selectNotificationSubject = PublishSubject<String?>();

  Stream<String?> get selectNotificationStream => _selectNotificationSubject.stream;

  final _didReceiveLocalNotificationSubject = PublishSubject<ReceivedNotification>();

  Stream<ReceivedNotification> get didReceiveLocalNotificationStream => _didReceiveLocalNotificationSubject.stream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static bool isNotification = false;

  Future<void> firebaseCloudMessagingLSetup() async {
    firebaseMessaging = FirebaseMessaging.instance;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    iOSPermission(firebaseMessaging);

    await firebaseMessaging.getToken().then((token) {
      // Constants.firebaseToken = token!;
      log('FCM TOKEN to be Registered: $token');
      print('FCM TOKEN to be Registered: $token');
      debugPrint('FCM TOKEN to be Registered: $token');
    });

    // Fired when app is coming from a terminated state
    // var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) _showLocalNotification(initialMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a “type” of “chat”,
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   NavigationUtils.notificationNavigationName = initialMessage.data['redirect'].toString();
    //   NavigationUtils.notificationKlokmateId = initialMessage.data['klokmateid'].toString();
    // }

    // Fired when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('receiveNotification onAppOpen onMessage data: ${message.data}');
      showLocalNotification(message);
      notificationBody.value = message.notification?.title?.toString() ?? '';
    });

    // Fired when app is in foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('receiveNotification onAppBackgroundOrClose onMessageOpenedApp data: ${message.data}');
      selectNotification(json.encode(message.data));
      debugPrint('Got a message, app is in the foreground! ${message.data.toString()}');
    });
  }

  Future<void> setUpLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async {
          _didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        selectNotification(details.payload);
      },
    );
    print("flutterLocalNotificationsPlugin Complete");
  }

  Future selectNotification(String? notificationPayload) async {
    if (notificationPayload != null && notificationPayload.isNotEmpty) {
      debugPrint('receiveNotification getInitialMessage 00');
      _selectNotificationSubject.add(notificationPayload);
    }
  }

  void iOSPermission(firebaseMessaging) {
    firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        playSound: true,
        //largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_largeIcon'),
        icon: '@mipmap/ic_launcher',
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, notification?.title ?? "", notification?.body ?? "", platformChannelSpecifics,
        payload: json.encode(message.data));

    // AndroidNotification? android = message.notification?.android;
    // flutterLocalNotificationsPlugin.show(
    //   notification.hashCode,
    //   notification!.title,
    //   notification.body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       // channel.description,
    //       // TODO add a proper drawable resource to android, for now using
    //       //      one that already exists in example app.
    //       icon: 'launch_background',
    //     ),
    //   ),
    // );
  }

  Future<void> localNotificationRequestPermissions() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void configureDidReceiveLocalNotificationSubject() {
    print('configureDidReceiveLocalNotificationSubject stream listen');
    didReceiveLocalNotificationStream.listen((ReceivedNotification receivedNotification) async {
      print("payloadNotification 01: $receivedNotification");
      // notificationToNavigate();
    });
  }

  void configureSelectNotificationSubject() {
    selectNotificationStream.listen((String? payload) {
      print('receiveNotification configureSelectNotificationSubject 00');
      Map data = payload != null ? json.decode(payload) : {};
      // NavigationUtils.navigationSwitch(data);
    });
  }

  void localNotificationDispose() {
    _didReceiveLocalNotificationSubject.close();
    _selectNotificationSubject.close();
  }

  static subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("all");
  }

  static unSubscribeToTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("all");
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
