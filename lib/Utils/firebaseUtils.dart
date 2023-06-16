import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/Utils/utils.dart';

class FirebaseUtils {
  Future<void> deleteDocument(
      String documentId, String email, BuildContext context) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('heyrajat');
      final notesref = FirebaseFirestore.instance.collection('notes');
      await collectionRef.doc(documentId).delete();
      await notesref.doc(documentId).delete().whenComplete(() async {
        Auth().addOrUpdateDocument(documentId, email);

        Utils.show_Simple_Snackbar(context, "Your data is reset");
      });
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future getuserdetails(String documentId, BuildContext context) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);
    try {
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        return snapshot.get("password");
      } else {
        Utils.show_Simple_Snackbar(
          context,
          "Contact Rajat at 8273024102",
        );
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error here
    }
  }
}
