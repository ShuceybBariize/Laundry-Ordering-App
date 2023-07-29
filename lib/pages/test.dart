// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/navigator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Noti {
//   static Future<void> initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//       GlobalKey<NavigatorState> navigatorKey) async {
//     var androidInitialize =
//         const AndroidInitializationSettings('mipmap/ic_launcher');
//     var initializationsSettings = InitializationSettings(
//       android: androidInitialize,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
//   }

//   static Future<void> showBigTextNotification({
//     int id = 0,
//     required String title,
//     required String body,
//     String? payload,
//     required FlutterLocalNotificationsPlugin fln,
//   }) async {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'you_can_name_it_whatever1',
//       'channel_name',
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('notification'),
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     var not = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//     await fln.show(id, title, body, not);
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import 'package:cloud_firestore/cloud_firestore.dart';

// // Function to get all staff device tokens from Firestore
// Future<List<String>> getStaffDeviceTokens() async {
//   List<String> deviceTokens = [];

//   try {
//     // Access the "users" collection in Firestore
//     CollectionReference usersCollection =
//         FirebaseFirestore.instance.collection('users');

//     // Query documents with the role "staff"
//     QuerySnapshot staffSnapshot =
//         await usersCollection.where('role', isEqualTo: 'staff').get();

//     // Iterate through the documents and get the device tokens
//     for (QueryDocumentSnapshot document in staffSnapshot.docs) {
//       String? deviceToken = document.get('deviceToken');
//       if (deviceToken != null) {
//         deviceTokens.add(deviceToken);
//       }
//     }
//   } catch (e) {
//     print('Error getting staff device tokens: $e');
//   }

//   return deviceTokens;
// }

// Future<void> sendNotificationsToStaff() async {
//   // Step 1: Get the device tokens of all staff members
//   List<String> staffDeviceTokens = await getStaffDeviceTokens();

//   if (staffDeviceTokens.isEmpty) {
//     print('No staff members found.');
//     return;
//   }

//   // Step 2: Send notifications to each staff member
//   String serverKey =
//       'AAAAs23xekk:APA91bESWPXzuhTzMkvbumu31NOHCl-Qn0r7dskr4REgUPo_Sc6cIkvhB2WK8HQYc9kXCKHEprmVDMBzDc6iM9ZjSRS3SKsFXnDnBboKH1eSDhyVgJklBj6_NMVl7ryZp7sKBIeAkkQN'; // Replace with your FCM server key

//   final Map<String, dynamic> notification = {
//     'body': 'There is a new pending order.', // Notification message
//     'title': 'New Order', // Notification title
//     'sound': 'default', // Notification sound (optional)
//   };

//   final Map<String, dynamic> data = {
//     'click_action':
//         'FLUTTER_NOTIFICATION_CLICK', // Action when notification is clicked (optional)
//     'payload': 'bending_order', // Payload data (optional)
//   };

//   final Map<String, dynamic> fcmMessage = {
//     'notification': notification,
//     'data': data,
//   };

//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=$serverKey',
//   };

//   try {
//     // Send notifications to each staff member
//     for (String deviceToken in staffDeviceTokens) {
//       fcmMessage['to'] = deviceToken;
//       final response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: headers,
//         body: jsonEncode(fcmMessage),
//       );

//       if (response.statusCode == 200) {
//         print(
//             'Notification sent successfully to staff member with device token: $deviceToken');
//       } else {
//         print(
//             'Failed to send notification to staff member with device token: $deviceToken. Status code: ${response.statusCode}');
//       }
//     }
//   } catch (e) {
//     print('Error sending notifications to staff members: $e');
//   }
// }
