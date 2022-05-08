import 'package:abbts/DriverHomePage.dart';
import 'package:abbts/Globals.dart';
import 'package:abbts/LoginPage.dart';
import 'package:abbts/ParentHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

FirebaseFirestore newInstance = FirebaseFirestore.instance;
FirebaseApp? app;
FirebaseStorage? storage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();
  storage = FirebaseStorage.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(mainColor);
    return MaterialApp(
      routes: {
        '/': (context) => const LoginPage(),
        '/second': (context) => const ParentHomePage(),
        '/third': (context) => const DriverHomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Android Based Bus Tracking System',
      builder: EasyLoading.init(),
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          ),
    );
  }
}
