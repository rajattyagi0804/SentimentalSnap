import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  bool isload = true;
  int streak = 0;
  int diff = 2;
  String background =
      "https://firebasestorage.googleapis.com/v0/b/hey-rajat.appspot.com/o/whitebackground.jpeg?alt=media&token=58598a87-88f5-4d28-bc7d-e76e4211e609";

  void adddata(String documentId, String arrayname) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data[arrayname] = [];
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

  void updatebackground(String documentId, String backgroundstring) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      List url = [snapshot.get("background")];
      deletePhotos(url);
      await docRef.set({"background": backgroundstring},
          SetOptions(merge: true)).whenComplete(() {
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
            key != "time" &&
            key != "streak" &&
            key != "background" &&
            key != "7days" &&
            key != "30days" &&
            key != "90days" &&
            key != "180days" &&
            key != "365days") {
          momentarray.add(key);
        } else if (key == "background") {
          background = value;
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

  static final customchache = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 2), maxNrOfCacheObjects: 100000000));
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
                    if (value != null) {
                      updatebackground(widget.uid, value);
                    }
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
              if (value == 2) {
                updatebackground(widget.uid,
                    "https://firebasestorage.googleapis.com/v0/b/hey-rajat.appspot.com/o/whitebackground.jpeg?alt=media&token=58598a87-88f5-4d28-bc7d-e76e4211e609");

                Utils.show_Simple_Snackbar(
                    context, "Background remove successfully");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 1,
                  child: Text(
                    "Change Background",
                  )),
              const PopupMenuItem(
                  value: 2,
                  child: Text(
                    "Remove Background",
                  )),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  background,
                  cacheManager: customchache,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: isload
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: momentarray.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.horizontal,
                                background: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  // color: const Color.fromARGB(255, 64, 122, 67),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.delete, color: Colors.white),
                                      Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                secondaryBackground: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20)),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.edit, color: Colors.white),
                                      Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    newmoment.clear();
                                    createneewMOment(2, index);
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    Utils.alertpopup(
                                        title:
                                            "Are you Sure you want to delete your ${momentarray[index]} Moment?",
                                        buttontitle: "Yes",
                                        context: context,
                                        onclick: () {
                                          deletemoment(
                                              widget.uid, momentarray[index]);
                                          Navigator.pop(context);
                                        });
                                  }
                                },
                                child:
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
                                })),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ]),
          ),
        ],
      ),
    );
  }

  Widget listtile(String title, {required VoidCallback onclick}) {
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
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
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
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.deepPurple),
                  child: Text(ck == 1 ? "Create Moment" : "Update"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    newmoment.clear();
                    // reenternewpassword.clear();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.grey),
                  child: const Text("Cancel"),
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
      if (momentarray[i] == value ||
          value == "background" ||
          value == "streak" ||
          value == "email" ||
          value == "7days" ||
          value == "30days" ||
          value == "90days" ||
          value == "180days" ||
          value == "365days") {
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

  Future deletePhotos(List downloadUrl) async {
    try {
      for (String url in downloadUrl) {
        final Reference photoRef = FirebaseStorage.instance.refFromURL(url);
        await photoRef.delete();
      }
    } catch (e) {
      print('Error deleting photos: $e');
    }
  }

  void deletemoment(String documentId, String oldArrayName) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey(oldArrayName)) {
        // Get the array value
        List<dynamic> arrayValue = data[oldArrayName];

        // Remove the old array from the data
        data.remove(oldArrayName);

        // Update the document with the modified data
        await docRef.set(data).whenComplete(() {
          setState(() {
            deletePhotos(arrayValue);
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
}
