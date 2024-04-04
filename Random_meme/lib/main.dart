import 'package:flutter/material.dart';
import 'package:random_meme/MainScreen.dart';
import 'package:random_meme/SplashScreen.dart';

void main() {
  runApp(MaterialApp(
     debugShowCheckedModeBanner: false,
    initialRoute: 'SplashScreen',
    routes: {
      'MainScreen': (context) => MainScreen(),
      'SplashScreen': (context) => SplashScreen(),

    },
  ));
}
