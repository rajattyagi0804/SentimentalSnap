import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/createNotes.dart';
import 'package:hey_rajat/Utils/utils.dart';

class NotesData extends StatefulWidget {
  String title, date, thought;
  bool lock;
  int index;
  String uid;

  NotesData(
      {super.key,
      required this.title,
      required this.date,
      required this.thought,
      required this.lock,
      required this.index,
      required this.uid});

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
        });

        print(notesList);
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
                  color: Colors.black,
                  onPressed: () {},
                  icon: const Icon(Icons.lock))
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
