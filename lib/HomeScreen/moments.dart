import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hey_rajat/Utils/utils.dart';

class Moments extends StatefulWidget {
  String title, uid, role;

  Moments(
      {super.key, required this.title, required this.uid, required this.role});

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  List<dynamic> showimagelist = [];
  List deleteindex = [];
  List deleteurl = [];
  bool isload = true;
  bool value = false;
  static final customchache = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 2), maxNrOfCacheObjects: 100000000));
  void addData(String documentId, List<String> imageUrls, String key) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();

      var diffInDays = Utils.getDifferenceInDays(snapshot.get('time').toDate());
      print(diffInDays);
      print(snapshot.get('streak'));
      if (snapshot.exists) {
        if (imageUrls.isNotEmpty) {
          List<dynamic> momentsList = snapshot.get(key) ?? [];
          for (String imageUrl in imageUrls) {
            momentsList.add(imageUrl);
          }
          await docRef.set({
            key: momentsList,
          }, SetOptions(merge: true));
          getdata(documentId, key);

          if (diffInDays != 0) {
            await docRef.set({
              "streak": snapshot.get('streak') + 1,
              "time": Timestamp.now(),
            }, SetOptions(merge: true));
            value = true;
          }
          if (!snapshot.get('7days')) {
            if (snapshot.get('streak') > 6) {
              await docRef.set({"7days": true}, SetOptions(merge: true));
              value = true;
            }
          }

          if (!snapshot.get('30days')) {
            if (snapshot.get('streak') > 29) {
              await docRef.set({"30days": true}, SetOptions(merge: true));
              value = true;
            }
          }
          if (!snapshot.get('90days')) {
            if (snapshot.get('streak') > 89) {
              await docRef.set({"90days": true}, SetOptions(merge: true));
              value = true;
            }
          }
          if (!snapshot.get('180days')) {
            if (snapshot.get('streak') > 179) {
              await docRef.set({"180days": true}, SetOptions(merge: true));
              value = true;
            }
          }
          if (!snapshot.get('365days')) {
            if (snapshot.get('streak') > 364) {
              await docRef.set({"365days": true}, SetOptions(merge: true));
              value = true;
            }
          }
        }
      } else {
        Utils.show_Simple_Snackbar(
          context,
          "Kindly please contact to admin.",
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
      showimagelist.clear();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      for (int i = 0; i < data[key].length; i++) {
        showimagelist.add({"val": data[key][i], "check": false});
      }
      setState(() {
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
    super.initState();
    getdata(widget.uid, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, value);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          deleteselectedcheck()
              ? IconButton(
                  onPressed: () {
                    Utils.alertpopup(
                        buttontitle: "Yes",
                        context: context,
                        title: "Are you sure you want to delete the photos?",
                        onclick: () {
                          deleteindex.clear();
                          deleteurl.clear();
                          for (var i = 0; i < showimagelist.length; i++) {
                            if (showimagelist[i]['check']) {
                              deleteindex.add(i);
                              deleteurl.add(showimagelist[i]['val']);
                            }
                          }

                          deletePhotos(deleteurl, deleteindex, widget.title);

                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.black)
              : const SizedBox()
        ],
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
                                          imageUrl: showimagelist[index]['val'],
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
                        onDoubleTap: () {
                          // if (widget.role == "Admin") {
                          if (showimagelist[index]['check'] == true) {
                            setState(() {
                              showimagelist[index]['check'] = false;
                            });
                          } else {
                            setState(() {
                              showimagelist[index]['check'] = true;
                            });
                          }
                          // }
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: CachedNetworkImage(
                                cacheManager: customchache,
                                key: UniqueKey(),
                                imageUrl: showimagelist[index]['val'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: Text("Loading...")),
                              ),
                            ),
                            showimagelist[index]['check']
                                ? Positioned(
                                    top: 8,
                                    bottom: 8,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
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
            if (await Utils.checkGalleryPermissions()) {
              Utils.convertImagesToBase64(context).then((value) {
                addData(widget.uid, value, widget.title);
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

  bool deleteselectedcheck() {
    for (var i = 0; i < showimagelist.length; i++) {
      if (showimagelist[i]['check'] == true) {
        return true;
      }
    }
    return false;
  }

  void deleteValues(String documentId, List indices, String key) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(documentId);
    try {
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        List<dynamic> momentsList = snapshot.get(key) ?? [];

        indices.sort((a, b) => b.compareTo(a));
        print(indices);
        print(momentsList);
        for (int index in indices) {
          if (index >= 0 && index < momentsList.length) {
            momentsList.removeAt(index);
          }
        }
        await docRef
            .set({key: momentsList}, SetOptions(merge: true)).then((value) {
          getdata(documentId, key);
          setState(() {
            isload = true;
          });
        });
      } else {
        Utils.show_Simple_Snackbar(
          context,
          "Kindly please contact to admin.",
        );
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error here
    }
  }

  Future deletePhotos(List downloadUrl, List deleteindex, String key) async {
    try {
      for (String url in downloadUrl) {
        final Reference photoRef = FirebaseStorage.instance.refFromURL(url);
        await photoRef.delete();
      }
      deleteValues(widget.uid, deleteindex, key);
    } catch (e) {
      print('Error deleting photos: $e');
    }
  }
}
