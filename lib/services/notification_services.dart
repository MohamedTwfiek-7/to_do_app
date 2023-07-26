import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';

class NotifyHelper {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      sound: true,
      alert: true,
      badge: true,
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  initializeNotification() async {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  }



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  displayNotification({required String title, required String body})async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: 'Default_sound');
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  scheduledNotification() async{
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {//select notification
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
  debugPrint('notification payload: $payload');
  }
  await Get.to(NotificationScreen(payload: payload!));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void onDidReceiveLocalNotification(
  int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  Get.dialog(Text(body!));
  }
}
