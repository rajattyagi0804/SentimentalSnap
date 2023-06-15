import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/LoginPage/loginchoice.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/bottomnav.dart';
import 'package:hey_rajat/WidgetScreen/widget.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List user = [];
  bool isload = true;
  void getdata() async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    QuerySnapshot querySnapshot = await colRef.get();
    List<DocumentSnapshot> documents = await querySnapshot.docs;
    for (var document in documents) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        user.add({'uid': document.id, 'email': data['email']});
      }
    }
    setState(() {
      isload = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: const [
              Text(
                "Hello Mr. admin",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Rajattyagi0804",
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
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
        body: isload
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : user.isEmpty
                ? const Center(
                    child: Text("NO user found"),
                  )
                : ListView.builder(
                    itemCount: user.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.orange,
                          shape: const StadiumBorder(),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomNav(
                                          uid: user[index]['uid'],
                                          email: user[index]['email'],
                                          role: "Admin",
                                        )));
                          },
                          title: Text(
                            user[index]['email']
                                    .toString()
                                    .replaceAll('@gmail.com', '')[0]
                                    .toUpperCase() +
                                user[index]['email']
                                    .toString()
                                    .replaceAll('@gmail.com', '')
                                    .substring(1),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          subtitle: Text(
                            user[index]['email'].toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ));
  }
}
