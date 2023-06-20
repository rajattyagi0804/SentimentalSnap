import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hey_rajat/Admin/adminScreen.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:hey_rajat/WidgetScreen/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailandPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("uid", "${value.user?.uid}");

      sp.setString('email', value.user!.email.toString());

      addOrUpdateDocument(value.user?.uid, value.user?.email).whenComplete(() {
        if (value.user?.uid == "cKVYRq516fX6MyFh6kx3NwpcbCA2") {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => const AdminScreen()),
              ModalRoute.withName('/'));
          sp.setString('role', "Admin");
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => BottomNav(
                        uid: value.user!.uid.toString(),
                        email: value.user!.email.toString(),
                        role: "User",
                      )),
              ModalRoute.withName('/'));
          sp.setString('role', "User");
        }
      });
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addOrUpdateDocument(String? uuid, String? email) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(uuid);
    CollectionReference notesref =
        FirebaseFirestore.instance.collection("notes");
    DocumentReference notesdocref = notesref.doc(uuid);

    bool docExists =
        await docRef.get().then((docSnapshot) => docSnapshot.exists);

    bool notesdocExists =
        await notesdocref.get().then((docSnapshot) => docSnapshot.exists);
    if (!docExists) {
      await docRef.set({
        "7days": false,
        "30days": false,
        "90days": false,
        "180days": false,
        "365days": false,
        'email': email,
        'time': Timestamp.fromMillisecondsSinceEpoch(168717353641),
        'streak': 0,
        'goodmoments': [],
        'background':
            "https://firebasestorage.googleapis.com/v0/b/hey-rajat.appspot.com/o/whitebackground.jpeg?alt=media&token=58598a87-88f5-4d28-bc7d-e76e4211e609"
      });
    }
    if (!notesdocExists) {
      await notesdocref.set({'mynote': [], 'password': ""});
    }
  }
  // addNotesCollection(String? uuid){

  // }
}
