import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailandPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("uid", "${value.user?.uid}");
      addOrUpdateDocument(value.user?.uid).whenComplete(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()));
      });
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // for creating collection

  Future<void> addOrUpdateDocument(String? uuid) async {
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("heyrajat");
    DocumentReference docRef = colRef.doc(uuid);

    bool docExists =
        await docRef.get().then((docSnapshot) => docSnapshot.exists);

    if (!docExists) {
      await docRef.set({
        'badmoments': [],
        'enjoyfulmoments': [],
        'goodmoments': [],
        'othermoments': []
      });
    }
  }
}
