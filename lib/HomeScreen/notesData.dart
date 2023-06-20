import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/createNotes.dart';
import 'package:hey_rajat/Utils/utils.dart';

class NotesData extends StatefulWidget {
  String title, date, thought;
  bool lock;
  int index;
  String uid;
  String password;

  NotesData(
      {super.key,
      required this.title,
      required this.date,
      required this.thought,
      required this.lock,
      required this.index,
      required this.uid,
      required this.password});

  @override
  State<NotesData> createState() => _NotesDataState();
}

class _NotesDataState extends State<NotesData> {
  String val = "no";

  void getnotes(String documentId, int index) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        List<dynamic> notesList = [];
        notesList = snapshot.get("mynote");
        setState(() {
          widget.title = notesList[index]['title'];
          widget.thought = notesList[index]['thought'];
          widget.date = notesList[index]['date'];
          widget.lock = notesList[index]['lock'];
        });

        print(notesList);
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

  void updatedata(String documentId, int index, bool newLockValue) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        List<dynamic> momentsList = snapshot.get("mynote");
        if (index >= 0 && index < momentsList.length) {
          Map<String, dynamic> note = momentsList[index];
          note["lock"] = newLockValue;
          momentsList[index] = note;

          await docRef.set({"mynote": momentsList},
              SetOptions(merge: true)).whenComplete(() {
            getnotes(documentId, index);
          });
        } else {
          print("Invalid index");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, val);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              widget.date,
              style: TextStyle(color: Colors.deepPurple, fontSize: 14),
            )
          ],
        ),
        actions: [
          widget.lock
              ? IconButton(
                  color: Colors.red,
                  onPressed: () {
                    val = "yes";
                    updatedata(widget.uid, widget.index, false);
                  },
                  icon: const Icon(Icons.lock))
              : widget.password != ""
                  ? IconButton(
                      color: Colors.green,
                      onPressed: () {
                        val = "yes";
                        updatedata(widget.uid, widget.index, true);
                      },
                      icon: const Icon(Icons.lock_open))
                  : SizedBox(),
          IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNote(
                              title: widget.title,
                              thought: widget.thought,
                              from: "edit",
                              index: widget.index,
                              uid: widget.uid,
                            ))).then((value) {
                  if (value['check'] == "yes") {
                    val = "yes";
                    getnotes(widget.uid, value['index']);
                  }
                });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              widget.thought,
              style: TextStyle(color: Colors.black, fontSize: 17),
            )),
      ),
    );
  }
}
