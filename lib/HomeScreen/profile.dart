import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class Profile extends StatefulWidget {
  String role, email, uid;
  Profile(
      {super.key, required this.role, required this.email, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isload = true;
  bool days7 = false;
  bool days30 = false;
  bool days90 = false;
  bool days180 = false;
  bool days365 = false;

  void getdata(String documentId) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      setState(() {
        days7 = snapshot.get("7days");
        days30 = snapshot.get("30days");
        days90 = snapshot.get("90days");
        days180 = snapshot.get("180days");
        days365 = snapshot.get("365days");
        isload = false;
      });
    } else {
      Utils.show_Simple_Snackbar(
        context,
        "Kindly please contact to admin.",
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata(widget.uid);
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            CircleAvatar(
              radius: 67,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 198, 8, 109),
                radius: 64,
                child: Text(
                  widget.email[0].toUpperCase(),
                  style: const TextStyle(fontSize: 60, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.email.replaceAll('@gmail.com', '')[0].toUpperCase() +
                  widget.email.replaceAll('@gmail.com', '').substring(1),
              style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.brown,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 1.5,
              color: Colors.blue,
            ),
            isload
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    'images/7days.png',
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: !days7
                                          ? const Color.fromARGB(
                                                  255, 245, 243, 243)
                                              .withOpacity(0.9)
                                          : null, // Apply a translucent gray color
                                    ),
                                  ),
                                  !days7
                                      ? Positioned(
                                          bottom: 60,
                                          left: 40,
                                          child: Container(
                                            child: const Text(
                                              "7 days",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 235, 137, 130),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                              !days7
                                  ? const SizedBox()
                                  : const Text(
                                      "7 days Streak",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    'images/30days.png',
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: !days30
                                          ? const Color.fromARGB(
                                                  255, 245, 243, 243)
                                              .withOpacity(0.9)
                                          : null, // Apply a translucent gray color
                                    ),
                                  ),
                                  !days30
                                      ? const Positioned(
                                          bottom: 60,
                                          left: 40,
                                          child: Text(
                                            "30 days",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 235, 137, 130),
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                              !days30
                                  ? const SizedBox()
                                  : const Text(
                                      "30 days Streak",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    'images/90days.png',
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: !days90
                                          ? const Color.fromARGB(
                                                  255, 245, 243, 243)
                                              .withOpacity(0.9)
                                          : null, // Apply a translucent gray color
                                    ),
                                  ),
                                  !days90
                                      ? const Positioned(
                                          bottom: 60,
                                          left: 40,
                                          child: Text(
                                            "90 days",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 235, 137, 130),
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                              !days90
                                  ? const SizedBox()
                                  : const Text(
                                      "90 days Streak",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    'images/180days.png',
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: !days180
                                          ? const Color.fromARGB(
                                                  255, 245, 243, 243)
                                              .withOpacity(0.9)
                                          : null, // Apply a translucent gray color
                                    ),
                                  ),
                                  !days180
                                      ? const Positioned(
                                          bottom: 60,
                                          left: 40,
                                          child: Text(
                                            "180 days",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 235, 137, 130),
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                              !days180
                                  ? const SizedBox()
                                  : const Text(
                                      "180 days Streak",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Stack(
                            children: <Widget>[
                              Image.asset(
                                'images/365days.png',
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: !days365
                                      ? const Color.fromARGB(255, 245, 243, 243)
                                          .withOpacity(0.9)
                                      : null, // Apply a translucent gray color
                                ),
                              ),
                              !days365
                                  ? const Positioned(
                                      bottom: 60,
                                      left: 40,
                                      child: Text(
                                        "365 days",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 235, 137, 130),
                                            fontWeight: FontWeight.bold),
                                      ))
                                  : const SizedBox()
                            ],
                          ),
                          !days365
                              ? const SizedBox()
                              : const Text(
                                  "365 days Streak",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                        ],
                      ),
                    ],
                  ),
          ]),
        ),
      ),
    );
  }
}
