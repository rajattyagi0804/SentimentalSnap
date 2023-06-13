import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Utils/utils.dart';

class Moments extends StatefulWidget {
  String title;
  Moments({super.key, required this.title});

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  List<dynamic> showimagelist = [];
  bool isload = true;

  void addDataToBadMoments(
      String documentId, List<dynamic> newData, String key) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> badMomentsList = data[key];
      badMomentsList.addAll(newData);
      await docRef.set({key: badMomentsList}, SetOptions(merge: true));
      setState(() {
        isload = true;
        getdata(documentId, key);
      });
    } else {
      Flushbar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color.fromARGB(255, 230, 225, 225),
        message: "Contact to Rajat 8273024102",
        messageColor: Colors.red,
      ).show(context);
    }
  }

  void getdata(String documentId, String key) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      showimagelist = data[key];
      setState(() {
        isload = false;
      });
    } else {
      Flushbar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color.fromARGB(255, 230, 225, 225),
        message: "Contact to Rajat 8273024102",
        messageColor: Colors.red,
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.getuid().then((value) {
      if (widget.title == "Good Moments") {
        getdata(value, 'goodmoments');
      } else if (widget.title == "Bad Moments") {
        getdata(value, 'badmoments');
      } else if (widget.title == "EnjoyFul Moments") {
        getdata(value, 'enjoyfulmoments');
      } else if (widget.title == "Other Moments") {
        getdata(value, 'othermoments');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: isload == true
          ? const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.amber),
            )
          : showimagelist.isEmpty
              ? Center(
                  child: Image.asset('images/noimagefound.webp'),
                )
              : GridView.builder(
                  itemCount: showimagelist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      content: SizedBox(
                                          child: Image.memory(
                                        Utils.convertbase64toimage(
                                            showimagelist[index]),
                                      )),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actionsOverflowButtonSpacing: 8.0,
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text(
                                            "close",
                                          ),
                                        )
                                      ]));
                        },
                        child: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: Image.memory(
                            Utils.convertbase64toimage(showimagelist[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                ),
      floatingActionButton: Container(
        constraints: const BoxConstraints(minWidth: 130),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),

        // Adjust the color to your preference
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 228, 163, 12),
          onPressed: () async {
            if (await Utils.checkCameraPermissions()) {
              Utils.convertimagetobase64().then((value) {
                Utils.getuid().then((uuid) {
                  if (widget.title == "Good Moments") {
                    addDataToBadMoments(uuid, value, 'goodmoments');
                  } else if (widget.title == "Bad Moments") {
                    addDataToBadMoments(uuid, value, 'badmoments');
                  } else if (widget.title == "EnjoyFul Moments") {
                    addDataToBadMoments(uuid, value, 'enjoyfulmoments');
                  } else if (widget.title == "Other Moments") {
                    addDataToBadMoments(uuid, value, 'othermoments');
                  }
                });
              });
            }

            if (!await Utils.checkCameraPermissions()) {
              Utils.gallerypermisionpopup(
                  title: "Camera Permission is required",
                  buttontitle: "Camera settings",
                  context: context,
                  onclick: () {
                    Navigator.pop(context);
                    AppSettings.openAppSettings();
                  });
            }
          },
          shape: const StadiumBorder(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(width: 4.0),
              Text("Add Photo",
                  style: TextStyle(
                    fontSize: 14.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
