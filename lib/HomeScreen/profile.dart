import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class Profile extends StatefulWidget {
  String role, email;
  Profile({super.key, required this.role, required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: widget.role != "Admin" ? Colors.white : Colors.black),
        backgroundColor: Colors.white,
        title: Column(
          children: const [
            Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          widget.role == "Admin"
              ? const SizedBox()
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                child: Text(
                  widget.email[0].toUpperCase(),
                  style: const TextStyle(fontSize: 60),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.email.replaceAll('@gmail.com', '')[0].toUpperCase() +
                    widget.email.replaceAll('@gmail.com', '').substring(1),
                style:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const Divider(
            thickness: 1.5,
          )
        ]),
      ),
    );
  }
}
