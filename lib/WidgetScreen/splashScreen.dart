import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/dashboard.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => WidgetScreen().gettoken().then((value) {
              if (value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            color: Colors.white,
            child: Image.asset(
              'images/sp.jpg',
              fit: BoxFit.cover,
            )),
        // Positioned(
        //     left: 120,
        //     right: 120,
        //     bottom: 90,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //           shape: const StadiumBorder(),
        //           elevation: 10,
        //           minimumSize: const Size(120, 50)),
        //       child: const Text("Continue >>"),
        //       onPressed: () {
        //         WidgetScreen().gettoken().then((value) {
        //           if (value) {
        //             Navigator.pushReplacement(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => const LoginScreen()));
        //           } else {
        //             Navigator.pushReplacement(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => const DashboardScreen()));
        //           }
        //         });
        //       },
        //     ))
      ],
    );
  }
}
