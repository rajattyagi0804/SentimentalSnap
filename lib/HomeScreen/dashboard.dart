import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/moments.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Welcome",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [
              card("Good Moments", "Save", "Your", "Good Moment", Colors.indigo,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Good Moments")));
              }),
              card("Bad Moments", "Save", "Your", "Bad Moment", Colors.blueGrey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Bad Moments")));
              })
            ],
          ),
          Row(
            children: [
              card("EnjoyFul Moments", "Save", "Your", "EnjoyFul Moment",
                  Colors.green, onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Moments(title: "EnjoyFul Moments")));
              }),
              card("Other Moments", "Save", "Your", "Other Moment", Colors.grey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Other Moments")));
              })
            ],
          )
        ]),
      ),
    );
  }

  Widget card(
    String title,
    String subtitle1,
    String subtitle2,
    String subtitle3,
    Color color, {
    required VoidCallback onclick,
  }) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Card(
            color: color,
            elevation: 10,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Divider(
                    thickness: 1.2,
                    color: Colors.white,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "$subtitle1\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text: "$subtitle2\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red)),
                        TextSpan(
                            text: "$subtitle3",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.amber))
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }
}
