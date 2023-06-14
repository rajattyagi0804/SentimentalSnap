import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/HomeScreen/moments.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

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
        title: Column(
          children: [
            const Text(
              "Welcome",
              style: TextStyle(color: Colors.black),
            ),
            const Text(
              "How are you today?",
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Utils.alertpopup(
                    buttontitle: "Yes",
                    context: context,
                    title: "Are you sure you want to Logout?",
                    onclick: () {
                      WidgetScreen().remove().then((value) => {
                            Auth().signOut(),
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginScreen()),
                                ModalRoute.withName('/'))
                          });
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              )),
        ],
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/awesome.jpg"), fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              card("Good Moments", 'images/enjoyed.jpeg',
                  const Color.fromARGB(255, 109, 127, 230), onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Good Moments")));
              }),
              const SizedBox(
                height: 5,
              ),
              card("Bad Moments", 'images/badmoments.jpeg', Colors.blueGrey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Bad Moments")));
              }),
              const SizedBox(
                height: 5,
              ),
              card("EnjoyFul Moments", 'images/enjoyment.jpg', Colors.green,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Moments(title: "EnjoyFul Moments")));
              }),
              const SizedBox(
                height: 5,
              ),
              card("Other Moments", 'images/othermoments.jpeg', Colors.grey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(title: "Other Moments")));
              })
            ]),
          ),
        ),
      ),
    );
  }

  Widget card(
    String title,
    String image,
    Color color, {
    required VoidCallback onclick,
  }) {
    return GestureDetector(
        onTap: onclick,
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Save your $title",
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 4, 1, 1)),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 27,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(image),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ));
  }
}
