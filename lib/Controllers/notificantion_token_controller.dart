// import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class TokenController extends GetxController {
//   var fcmToken = ''.obs;



//   Future<void> initializeFCM(id, isAdmin) async {
//     // Request permission (necessary for iOS)
//     await FirebaseMessaging.instance.requestPermission();

//     // Get the initial token
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       fcmToken.value = token;
//       await _storeToken(token, id, isAdmin);  // Store token based on user type
//     }

//     // Listen for token refreshes
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       _onTokenRefresh(newToken, id, isAdmin);  // Update Firestore if token refreshes
//     });
//   }

//   void _onTokenRefresh(String newToken, id, isAdmin) async {
//     fcmToken.value = newToken;
//     await _storeToken(newToken, id ,isAdmin);
//   }

//   Future<void> _storeToken(String token, id, isAdmin) async {
//     // If the user is an admin, store the token in the `admins` collection
//     if (isAdmin) {
//       await FirebaseFirestore.instance.collection('Admin').doc(id).set(
//         {'fcm_token': token},
//         SetOptions(merge: true),  // Merge to avoid overwriting other fields
//       );
//     } else {
//       // For regular users, store the token in the `users` collection
//       await FirebaseFirestore.instance.collection('User').doc(id).set(
//         {'fcm_token': token},
//         SetOptions(merge: true),
//       );
//     }
//   }
// }
