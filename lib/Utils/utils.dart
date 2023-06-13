import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static convertbase64toimage(String thumbnail) {
    String placeholder =
        "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
    if (thumbnail.isEmpty)
      thumbnail = placeholder;
    else {
      if (thumbnail.length % 4 > 0) {
        thumbnail +=
            '=' * (4 - thumbnail.length % 4); // as suggested by Albert221
      }
    }
    final _byteImage = const Base64Decoder().convert(thumbnail);

    return _byteImage;
  }

  //permission of gallery
  static void gallerypermisionpopup(
      {required String title,
      required String buttontitle,
      required VoidCallback onclick,
      required BuildContext context}) {
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
              child: const Text("No"),
              isDestructiveAction: true,
            ),
          ],
        );
      },
    );
  }

  //for Camera permisiion
  static Future<bool> checkCameraPermissions() async {
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

  static Future<List<String>> convertimagetobase64() async {
    List<Asset> assets = [];
    List<String> base64Images = [];

    try {
      assets = await MultiImagePicker.pickImages(
        maxImages: 10, // Specify the maximum number of images to select
        enableCamera: true, // Allow capturing images from the camera
        selectedAssets:
            assets, // Initially selected assets (empty in this example)
        materialOptions: const MaterialOptions(
          actionBarTitle: "Select Images",
        ),
      );
    } on Exception catch (e) {
      // Handle any errors that occurred during image selection
      print(e.toString());
    }

    for (var asset in assets) {
      // Retrieve the image data as bytes
      ByteData byteData = await asset.getByteData();
      List<int> imageBytes = byteData.buffer.asUint8List();

      // Convert the image bytes to base64
      String base64Image = base64Encode(imageBytes);

      base64Images.add(base64Image);
    }

    return base64Images;
  }

  static Future getuid() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String uid = sp.getString("uid")!;
    return uid;
  }
}
