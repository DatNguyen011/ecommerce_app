import 'dart:developer';

import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';

late Size mq;

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); //enter full-screen
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //
  // //for setting orientation to portrait only
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  //     .then((value) {
  //   // _initializeFirebase();
  //
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
            )),
        home: const LoginScreen());
  }
}
// _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   var result = await FlutterNotificationChannel.registerNotificationChannel(
//       description: 'For Showing Message Notification',
//       id: 'chats',
//       importance: NotificationImportance.IMPORTANCE_HIGH,
//       name: 'Chats');
//   log('\nNotification Channel Result: $result');
// }

