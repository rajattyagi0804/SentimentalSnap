import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/moments.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  String uid, email, role;
  DashboardScreen(
      {super.key, required this.uid, required this.email, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  TextEditingController newmoment = TextEditingController();
  int arraychecker = 1;
  bool isload = true;
  int streak = 0;
  int diff = 2;

  void adddata(String documentId, String arrayname) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data[arrayname] = [];
      data["arraychecker"] = snapshot.get('arraychecker') + 1;
      await docRef.set(data, SetOptions(merge: true)).whenComplete(() {
        setState(() {
          isload = false;
          getdata(documentId);
        });
      });
    } else {
      Utils.show_Simple_Snackbar(
        context,
        "Contact Rajat at 8273024102",
      );
    }
  }

  void update(
      String documentId, String oldArrayName, String newArrayName) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Check if the old array name exists
      if (data.containsKey(oldArrayName)) {
        // Get the array value
        List<dynamic> arrayValue = data[oldArrayName];

        // Remove the old array from the data
        data.remove(oldArrayName);
        // print(data);
        // // Add the new array with the new name
        data[newArrayName] = arrayValue;

        // Update the document with the modified data
        await docRef.set(data).whenComplete(() {
          setState(() {
            isload = false;
            getdata(documentId);
          });
        });
      } else {
        Utils.show_Simple_Snackbar(
          context,
          "The old array name does not exist.",
        );
      }
    } else {
      Utils.show_Simple_Snackbar(
        context,
        "Contact Rajat at 8273024102",
      );
    }
  }

  List momentarray = [];
  void getdata(String documentId) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      momentarray.clear();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      Duration difference =
          Timestamp.now().toDate().difference(snapshot.get('time').toDate());
      if (difference.inDays > 1) {
        await docRef.set({"streak": 0}, SetOptions(merge: true));
      }
      data.forEach((key, value) {
        if (key != "email" &&
            key != "arraychecker" &&
            key != "time" &&
            key != "streak") {
          momentarray.add(key);
        } else if (key == "arraychecker") {
          arraychecker = value;
        } else if (key == "streak") {
          if (difference.inDays > 1) {
            streak = 0;
          } else {
            streak = value;
          }
        }
      });

      setState(() {
        isload = false;
        diff = difference.inDays;
      });
    } else {
      Utils.show_Simple_Snackbar(
        context,
        "Contact to Rajat 8273024102",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getdata(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.role == "Admin"
            ? BackButton(
                color: widget.role != "Admin" ? Colors.white : Colors.black)
            : const SizedBox(),
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              widget.email.replaceAll('@gmail.com', '')[0].toUpperCase() +
                  widget.email.replaceAll('@gmail.com', '').substring(1),
              style: const TextStyle(
                  color: Colors.brown,
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        // centerTitle: true,
        actions: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department_sharp,
                color: diff == 0 ? Colors.redAccent : Colors.grey,
                size: 30.0,
              ),
              Text(
                streak.toString(),
                style: TextStyle(
                    color: diff == 0 ? Colors.redAccent : Colors.grey,
                    fontSize: 19),
              ),
            ],
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (value) async {
              if (value == 1) {
                if (await Utils.checkGalleryPermissions()) {
                  imageOnClick().then((value) {
                    print(value);
                  });
                }

                if (!await Utils.checkGalleryPermissions()) {
                  Utils.alertpopup(
                      title: "Gallery Permission is required",
                      buttontitle: "app permission",
                      context: context,
                      onclick: () {
                        Navigator.pop(context);
                        AppSettings.openAppSettings();
                      });
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 1,
                  child: Text(
                    "Change Background",
                  )),
            ],
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg.jpg"), fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: isload
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ListView.builder(
                          itemCount: momentarray.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                listtile(momentarray[index], onclick: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Moments(
                                                  title: momentarray[index],
                                                  uid: widget.uid,
                                                  role: widget.role)))
                                      .then((value) {
                                    if (value) {
                                      getdata(widget.uid);
                                    }
                                  });
                                }, editclick: () {
                                  newmoment.clear();
                                  createneewMOment(2, index);
                                }),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        arraychecker <= 3
                            ? GestureDetector(
                                onTap: () {
                                  newmoment.clear();
                                  createneewMOment(1, 0);
                                },
                                child: Container(
                                  height: 65,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Text(
                                    "+ Add new Moment",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ]),
          ),
        ),
      ),
    );
  }

  Widget listtile(String title,
      {required VoidCallback onclick, required VoidCallback editclick}) {
    return GestureDetector(
        onTap: onclick,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            title: Text(
              title[0].toUpperCase() + title.substring(1),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Save your $title",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 4, 1, 1)),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 27,
              child: CircleAvatar(
                backgroundColor: Colors.amberAccent,
                radius: 25,
                child: Text(title[0].toUpperCase()),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: editclick,
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ));
  }

  createneewMOment(int ck, int index) {
    return showDialog(
      context: context,
      builder: (tt) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  ck == 1 ? "Add New Moment" : "Update Name",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _FormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: newmoment,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //add prefix icon

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "Write your moment name",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'Moment Name',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter the moment name';
                          }
                          return check(value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValidForm = _FormKey.currentState!.validate();
                    if (isValidForm) {
                      if (ck == 1) {
                        adddata(widget.uid,
                            newmoment.text.trim().replaceAll(' ', ''));
                      } else if (ck == 2) {
                        update(widget.uid, momentarray[index],
                            newmoment.text.trim().replaceAll(' ', ''));
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(ck == 1 ? "Create Moment" : "Update"),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    newmoment.clear();
                    // reenternewpassword.clear();
                  },
                  child: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  check(String value) {
    for (var i = 0; i < momentarray.length; i++) {
      print(momentarray);
      if (momentarray[i] == value) {
        return "Please choose another name this name already exists";
      }
    }
  }

  Future<String?> imageOnClick() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.front,
    );

    if (file != null) {
      // Convert image to bytes
      List<int> imageBytes = await file.readAsBytes();

      ;
      return Utils.backgroundimageupload(imageBytes);
    } else {
      return null;
    }
  }
}
