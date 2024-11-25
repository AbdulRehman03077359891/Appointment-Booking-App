import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:appointment_booking_app/Screen/Admin/admin_view_req.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocNotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermissions(context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print("granted permission for notifications");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print("granted provisional permission for notifications");
    } else {
      // print("denied permission for notifications");
      _showSettingsBottomSheet(context);
    }
  }

  // Professional bottom sheet UI for guiding the user to the settings page
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications_off,
                    size: 30, color: Colors.redAccent),
                SizedBox(width: 10),
                Text(
                  "Notifications Disabled",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "To stay updated with the latest notifications, please enable notifications in your device settings.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Open the app settings
                AppSettings.openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Open Settings",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidinitializationsettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: androidinitializationsettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      } else {
        showNotifications(message);
      }
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), "doctor_channel_id",
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: "Your Channel Description",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    if (message.data['type'] == 'msj') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewRequests(
                  userUid: prefs.getString("userUid").toString(),
                  userName: prefs.getString("userName").toString(),
                  userEmail: prefs.getString("userEmail").toString())));
    }
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // When app is terminated then on notification tap
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // when app is in Background then on notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  // void storeDoctorFCMToken(String doctorUid, String token) async {
  //   final doctorRef =
  //       FirebaseFirestore.instance.collection('Doctor').doc(doctorUid);
  //   await doctorRef.update({
  //     'fcm_token': token,
  //   });
  //   // print("Doctor FCM Token stored: $token");
  // }

  void listenForNewRequests(String doctorUid) {
    FirebaseFirestore.instance
        .collection('Requests')
        .where("status", isEqualTo: "pending" )
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // New request added, trigger local notification
          String userName = change.doc.data()?['userName'];
          showLocalNotification(
              "New Ambulance Request", "New Request from: $userName");
        }
      }
    });
  }


  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'new_requests_channel', // id
      'New Requests', // title
      description: 'Channel for new ambulance requests notifications',
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      ledColor: Colors.blueAccent, // Custom LED color for notification
      playSound: true, // Enables sound for notifications
    );
// Create the notification channel on Android if it's not already created
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Custom sound (optional), put the sound file in `res/raw` folder
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'new_requests_channel', // channel ID
      'New Requests', // channel name
      channelDescription: 'Channel for new ambulance requests notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher', // Custom notification icon
      largeIcon: const DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher'), // Constant large icon
      color: Colors.redAccent, // Custom color for notification background
      ledColor: Colors.blueAccent,
      ledOnMs: 1000, // Duration of LED on
      ledOffMs: 500, // Duration of LED off
      vibrationPattern:
          Int64List.fromList([0, 1000, 500, 2000]), // Custom vibration pattern
      playSound: true, // Enable sound
      sound: const RawResourceAndroidNotificationSound('notification_sound'), // Constant sound
      styleInformation: BigTextStyleInformation(
        body, // Non-constant value
        contentTitle: title, // Non-constant value
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
      ),
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title, // notification title
      body, // notification body
      notificationDetails,
    );
  }

// void listenForNewRequests(String doctorUid) {
//   FirebaseFirestore.instance.collection('Requests').snapshots().listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         // New request added, trigger notification to doctor
//         String requestDetails = "New Request from: ${change.doc.data()?['userName']}";
//         sendNotificationTodoctor(doctorUid, "New Ambulance Request", requestDetails);
//       }
//     }
//   });
// }

// Future<void> sendNotificationToDoctor(String doctorUid, String title, String body) async {
//   final doctorRef = FirebaseFirestore.instance.collection('doctor').doc(doctorUid);
//   final doc = await doctorRef.get();

//   if (doc.exists) {
//     String? fcmToken = doc.data()?['fcm_token'];
//     if (fcmToken != null) {
//       // Trigger notification using the FCM token
//       await sendPushMessage(fcmToken, title, body);
//       print("Notification sent to doctor: $fcmToken");
//     }
//   }
// }

// Future<void> sendPushMessage(String token, String title, String body) async {
//   try {
//     await FirebaseMessaging.instance.sendMessage(
//       to: token,
//       data: {
//         'title': title,
//         'body': body,
//       },
//     );
//     print('Push message sent');
//   } catch (e) {
//     print('Error sending push message: $e');
//   }
// }
}
