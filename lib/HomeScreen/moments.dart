import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Moments extends StatefulWidget {
  String title;
  Moments({super.key, required this.title});

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  List<dynamic> rr = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5];

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
      body: GridView.builder(
        itemCount: rr.length,
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
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            content: SizedBox(
                                child: Image.network(
                              "https://plus.unsplash.com/premium_photo-1677607235809-7c5f0b240117?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                              fit: BoxFit.fill,
                            )),
                            actionsAlignment: MainAxisAlignment.center,
                            actionsOverflowButtonSpacing: 8.0,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text(
                                  "close",
                                ),
                              )
                            ]));
              },
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Image.network(
                  "https://plus.unsplash.com/premium_photo-1677607235809-7c5f0b240117?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
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
        decoration: const BoxDecoration(shape: BoxShape.circle),

        // Adjust the color to your preference
        child: FloatingActionButton(
          onPressed: () async {
            if (await checkCameraPermissions()) {
              imageOnClick().then((value) {
                print(value);
              });
            }

            if (!await checkCameraPermissions()) {
              locationPopUp(
                  title: "Camera Permission is required",
                  buttontitle: "Camera settings",
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
              Icon(Icons.add),
              SizedBox(width: 4.0),
              Text("Add Photo", style: TextStyle(fontSize: 14.0)),
            ],
          ),
        ),
      ),
    );
  }

  //for Camera permisiion
  Future<bool> checkCameraPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus.isDenied) return false;
    }
    if (status.isPermanentlyDenied) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }
    return true;
  }

// open and click the picture
  Future<String?> imageOnClick() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file != null) {
      // Convert image to bytes
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      String header = "data:image/png;base64,";

      return header + base64Image;
    } else {
      return null;
    }
  }

  void locationPopUp({
    required String title,
    required String buttontitle,
    required VoidCallback onclick,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Icon(Icons.paragliding),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: onclick,
              child: Text(buttontitle),
              isDefaultAction: true,
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
              isDestructiveAction: true,
            ),
          ],
        );
      },
    );
  }
}
