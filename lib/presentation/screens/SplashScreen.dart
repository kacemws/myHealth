
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    print("doing something");
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}