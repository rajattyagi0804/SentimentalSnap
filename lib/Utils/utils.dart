import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  //permission of gallery
  static void alertpopup(
      {required String title,
      required String buttontitle,
      required VoidCallback onclick,
      required BuildContext context}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              onPressed: onclick,
              child: Text(buttontitle),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            )
          ],
        );
      },
    );
  }

  static Future<bool> checkGalleryPermissions() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await Permission.storage.request();

      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  static Future<String> uploadImageToStorage(
    List<int> imageBytes,
    int currentIndex,
    int totalPhotos,
    ProgressDialog progressDialog,
  ) async {
    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage location
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      // Convert the image bytes to a Uint8List
      Uint8List uint8List = Uint8List.fromList(imageBytes);

      // Upload the image data to Firebase Storage
      firebase_storage.UploadTask uploadTask = storageRef.putData(uint8List);

      // Listen to the task snapshot for progress updates
      uploadTask.snapshotEvents
          .listen((firebase_storage.TaskSnapshot snapshot) {
        double totalProgress = 0.0;

        if (totalPhotos > 0) {
          double progressPerPhoto = 100.0 / totalPhotos;
          double currentPhotoProgress =
              (snapshot.bytesTransferred / snapshot.totalBytes) *
                  progressPerPhoto;
          totalProgress =
              (currentIndex - 1) * progressPerPhoto + currentPhotoProgress;
        }

        progressDialog.update(
          message:
              "Uploading Photo $currentIndex of $totalPhotos (${totalProgress.toStringAsFixed(2)}%)",
        );
      });

      // Wait for the upload task to complete
      await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await storageRef.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  static Future<String> backgroundimageupload(
    List<int> imageBytes,
  ) async {
    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage location
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      // Convert the image bytes to a Uint8List
      Uint8List uint8List = Uint8List.fromList(imageBytes);

      // Upload the image data to Firebase Storage
      firebase_storage.UploadTask uploadTask = storageRef.putData(uint8List);

      // Listen to the task snapshot for progress updates
      uploadTask.snapshotEvents
          .listen((firebase_storage.TaskSnapshot snapshot) {
        double totalProgress = 0.0;
      });

      // Wait for the upload task to complete
      await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await storageRef.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  static Future<List<String>> convertImagesToBase64(
      BuildContext context) async {
    List<Asset> assets = [];
    List<String> imageUrls = [];

    try {
      assets = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: assets,
        materialOptions: const MaterialOptions(
          actionBarTitle: "Select Images",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
      // Handle image selection error
    }

    if (assets.isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(
        isDismissible: false,
        context,
      ); // Set barrierDismissible to false
      progressDialog.style(
        message: "Uploading Images...",
        progressWidget: SizedBox(
          width: 36.0,
          height: 36.0,
          child: Transform.scale(
            scale: 0.7, // Adjust the scale value as needed
            child: const CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
          ),
        ),
      );
      progressDialog.show();

      for (var index = 0; index < assets.length; index++) {
        var asset = assets[index];
        // Retrieve the image data as bytes
        ByteData byteData = await asset.getByteData();
        List<int> imageBytes = byteData.buffer.asUint8List();

        // Upload image to Firebase Storage
        String imageUrl = await uploadImageToStorage(
          await compressImage(imageBytes),
          index + 1,
          assets.length,
          progressDialog,
        );

        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      progressDialog.hide();
    }

    return imageUrls;
  }

  static Future<List<int>> compressImage(List<int> imageBytes) async {
    Uint8List uint8List = Uint8List.fromList(imageBytes);
    final compressedBytes = await FlutterImageCompress.compressWithList(
      uint8List,
      minHeight: 1920,
      minWidth: 1080,
      quality: 70,
    );

    return compressedBytes;
  }

  static show_Simple_Snackbar(BuildContext context, String? message) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Color.fromARGB(240, 243, 250, 255),
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      messageColor: Colors.blue,
      positionOffset: 5.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      borderRadius: BorderRadius.circular(5),
      forwardAnimationCurve: Curves.linearToEaseOut,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      boxShadows: const [
        BoxShadow(
          color: Color.fromARGB(166, 195, 201, 206),
          offset: Offset(5, 5),
          blurRadius: 3,
        ),
      ],
      message: message ?? "",
    ).show(context);
  }
}
