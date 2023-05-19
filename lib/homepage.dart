
import 'dart:async';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3),
    //       ()=>Navigator.pushReplacement(context,
    //                                     MaterialPageRoute(builder:
    //                                                       (context) => 
    //                                                       SecondScreen()
    //                                                      )
    //                                    )
        //  );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.red,
          child:Image.asset('images/pic1.jpeg',fit: BoxFit.cover,)
        ),
        Container(
          child: Text("rajat"),
        )
      ],
    );
  }
}
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.red,
        elevation: 20,
      ),
      body: Column(
        children: [
          Card(
            elevation: 20,
            child:Text("sdsd")
          )
        ],
      ),
    );
  }
}