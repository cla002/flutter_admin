import 'dart:io';

import 'package:admin_app/screens/home_page.dart';
import 'package:admin_app/sidebar/views/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: "AIzaSyC4H4Jtm_BWEqYXS4gwXuvSq6SLWkhWEW8",
            authDomain: "e-tabo-firestore-81f42.firebaseapp.com",
            projectId: "e-tabo-firestore-81f42",
            storageBucket: "e-tabo-firestore-81f42.appspot.com",
            messagingSenderId: "439828281369",
            appId: "1:439828281369:web:9fc34f146cb0959dcbd288",
            measurementId: "G-DSV36558VS")
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Tabo Admin',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: MyHomePage(),
      builder: EasyLoading.init(),
      routes: {
        MainScreen.id: (context) => const MainScreen(
              userRole: 'admin',
            ),
        MyHomePage.id: (context) => MyHomePage(),
      },
    );
  }
}
