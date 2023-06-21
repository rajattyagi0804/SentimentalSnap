import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Admin/adminScreen.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';
import 'package:hey_rajat/WidgetScreen/bottomnav.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 3),
        () => WidgetScreen().getSharedprefrenceValue().then((value) {
              if (value['role'] == "") {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
              } else if (value['role'] == "Admin") {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => const AdminScreen()),
                );
              } else {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => BottomNav(
                              uid: value['uid'],
                              role: value['role'],
                              email: value['email'],
                            )));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset(
          'images/sp.jpg',
          fit: BoxFit.cover,
        ));
  }
}
