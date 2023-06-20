import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Utils/utils.dart';
import 'package:intl/intl.dart';

class CreateNote extends StatefulWidget {
  String title, thought, from;
  String uid;
  int index;
  CreateNote(
      {super.key,
      required this.thought,
      required this.title,
      required this.from,
      required this.index,
      required this.uid});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController title = TextEditingController();
  TextEditingController thought = TextEditingController();

  void addData(String documentId, String key) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);
    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        List<dynamic> momentsList = snapshot.get("mynote");

        momentsList.add({
          "date": DateFormat('EEEE, MMM d, yyyy, hh:mm a')
              .format(DateTime.now())
              .toString(),
          "lock": false,
          "title": title.text.trim().toString().isEmpty
              ? "Notes ${momentsList.length + 1}"
              : title.text.trim().toString(),
          "thought": thought.text.trim().toString()
        }); // Add the new map to the array

        await docRef.set(
            {"mynote": momentsList}, SetOptions(merge: true)).whenComplete(() {
          Navigator.pop(context, "yes");
          title.clear();
          thought.clear();
          ;
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

  void updatedata(String documentId, int index) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        List<dynamic> momentsList = snapshot.get("mynote");
        if (index >= 0 && index < momentsList.length) {
          Map<String, dynamic> note = momentsList[index];
          note["title"] = title.text.trim().toString();
          note["thought"] = thought.text.trim().toString();
          note["date"] = DateFormat('EEEE, MMM d, yyyy, hh:mm a')
              .format(DateTime.now())
              .toString();
          momentsList[index] = note;

          await docRef.set({"mynote": momentsList},
              SetOptions(merge: true)).whenComplete(() {
            Navigator.pop(context, {"check": "yes", "index": index});
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      title.text = widget.title;
      thought.text = widget.thought;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Utils.alertpopup(
                title: "Are you sure you want to exit?",
                buttontitle: "Yes",
                context: context,
                onclick: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Start writting...",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/notesbackground.jpg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.from == "edit" ? "Update Title" : "Title",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 17),
                          controller: title,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            // Add prefix icon
                            focusColor: Colors.black,

                            // Set the border outline color
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // Set the focused border outline color
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            fillColor: Colors.black,
                            hintText: "Enter Your title",
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: widget.from == "edit"
                                ? "Update Title"
                                : "Title",
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(color: Colors.black, fontSize: 17),
                controller: thought,
                keyboardType: TextInputType.multiline,
                maxLines: 12,
                decoration: InputDecoration(
                  focusColor: Colors.black,

                  // Set the border outline color
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  // Set the focused border outline color
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  fillColor: Colors.black,
                  hintText: "Write your thoughts...",
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ]),
            widget.from == "edit"
                ? ElevatedButton(
                    onPressed: () {
                      updatedata(widget.uid, widget.index);
                    },
                    child: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromWidth(200),
                        backgroundColor: Colors.purple,
                        shape: const StadiumBorder()),
                  )
                : ElevatedButton(
                    onPressed: () {
                      addData(widget.uid, "mynote");
                    },
                    child: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromWidth(200),
                        backgroundColor: Colors.purple,
                        shape: const StadiumBorder()),
                  )
          ],
        ),
      ),
    );
  }
}
