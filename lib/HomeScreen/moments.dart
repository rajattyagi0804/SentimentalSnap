import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hey_rajat/Utils/utils.dart';

class Moments extends StatefulWidget {
  String title, uid;
  Moments({super.key, required this.title, required this.uid});

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  List<dynamic> showimagelist = [];
  bool isload = true;
  static final customchache = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 2), maxNrOfCacheObjects: 100000000));
  void addData(String documentId, List<String> imageUrls, String key) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        if (imageUrls.isNotEmpty) {
          List<dynamic> momentsList = snapshot.get(key) ?? [];
          for (String imageUrl in imageUrls) {
            momentsList.add(imageUrl);
          }
          await docRef.set({key: momentsList}, SetOptions(merge: true));
          getdata(documentId, key);
        }
      } else {
        Utils.show_Simple_Snackbar(
          context,
          "Contact to Rajat 8273024102",
        );
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error here
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
      Utils.show_Simple_Snackbar(
        context,
        "Contact to Rajat 8273024102",
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.title == "Good Moments") {
      getdata(widget.uid, 'goodmoments');
    } else if (widget.title == "Bad Moments") {
      getdata(widget.uid, 'badmoments');
    } else if (widget.title == "EnjoyFul Moments") {
      getdata(widget.uid, 'enjoyfulmoments');
    } else if (widget.title == "Other Moments") {
      getdata(widget.uid, 'othermoments');
    }
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
                  child:
                      Image.asset('images/noimagefound.webp', cacheHeight: 100),
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
                                        child: CachedNetworkImage(
                                          cacheManager: customchache,
                                          key: UniqueKey(),
                                          imageUrl: showimagelist[index],
                                        ),
                                      ),
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
                          child: CachedNetworkImage(
                              cacheManager: customchache,
                              key: UniqueKey(),
                              imageUrl: showimagelist[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const Center(child: Text("Loading..."))),
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
              Utils.convertImagesToBase64(context).then((value) {
                if (widget.title == "Good Moments") {
                  addData(widget.uid, value, 'goodmoments');
                } else if (widget.title == "Bad Moments") {
                  addData(widget.uid, value, 'badmoments');
                } else if (widget.title == "EnjoyFul Moments") {
                  addData(widget.uid, value, 'enjoyfulmoments');
                } else if (widget.title == "Other Moments") {
                  addData(widget.uid, value, 'othermoments');
                }
              });
            }

            if (!await Utils.checkCameraPermissions()) {
              Utils.alertpopup(
                  title: "Gallery Permission is required",
                  buttontitle: "app permission",
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
