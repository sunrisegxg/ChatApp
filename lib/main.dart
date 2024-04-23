
import 'dart:io';

import 'package:app/services/auth/auth_page.dart';
import 'package:app/components/page_common.dart';
import 'package:app/intro/onboarding_screen.dart';
import 'package:app/themes/light_mode.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA7ezMyFp6lyhd2vnhZ5QXARZoCoeoJ5BU',
      appId: '1:234751558894:android:652e75069b55c91d889fff',
      messagingSenderId: '234751558894',
      projectId: 'fir-tutorial-35d29',
      storageBucket: "fir-tutorial-35d29.appspot.com",
    )
  ) : await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}


