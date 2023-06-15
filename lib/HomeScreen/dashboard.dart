import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/HomeScreen/moments.dart';
import 'package:hey_rajat/LoginPage/loginchoice.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class DashboardScreen extends StatefulWidget {
  String uid, email, role;
  DashboardScreen(
      {super.key, required this.uid, required this.email, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: widget.role != "Admin" ? Colors.white : Colors.black),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            const Text(
              "Welcome",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              widget.email.replaceAll('@gmail.com', '')[0].toUpperCase() +
                  widget.email.replaceAll('@gmail.com', '').substring(1),
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          widget.role == "Admin"
              ? SizedBox()
              : IconButton(
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
                                            const LoginAsUserOrAdmin()),
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
              listtile("Good Moments", 'images/enjoyed.jpeg',
                  const Color.fromARGB(255, 109, 127, 230), onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Moments(title: "Good Moments", uid: widget.uid)));
              }),
              const SizedBox(
                height: 5,
              ),
              listtile("Bad Moments", 'images/badmoments.jpeg', Colors.blueGrey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Moments(title: "Bad Moments", uid: widget.uid)));
              }),
              const SizedBox(
                height: 5,
              ),
              listtile("EnjoyFul Moments", 'images/enjoyment.jpg', Colors.green,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Moments(
                            title: "EnjoyFul Moments", uid: widget.uid)));
              }),
              const SizedBox(
                height: 5,
              ),
              listtile("Other Moments", 'images/othermoments.jpeg', Colors.grey,
                  onclick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Moments(title: "Other Moments", uid: widget.uid)));
              })
            ]),
          ),
        ),
      ),
    );
  }

  Widget listtile(
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
