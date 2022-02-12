import 'package:flutter/material.dart';
import 'package:lab3/view/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      title: 'MyFood',
      home: const Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
