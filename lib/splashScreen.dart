import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hey_rajat/loginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(Duration(seconds: 3),
  //         ()=>Navigator.pushReplacement(context,
  //                                       MaterialPageRoute(builder:
  //                                                         (context) =>
  //                                                         SecondScreen()
  //                                                        )
  //                                      )
  //    );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            color: Colors.red,
            child: Image.asset(
              'images/splash.jpeg',
              fit: BoxFit.cover,
            )),
        Positioned(
            left: 120,
            right: 120,
            bottom: 90,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 10,
                  minimumSize: const Size(120, 50)),
              child: const Text("Continue >>"),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ))
      ],
    );
  }
}
