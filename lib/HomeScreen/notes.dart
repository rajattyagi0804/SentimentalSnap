import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/createNotes.dart';
import 'package:hey_rajat/HomeScreen/notesData.dart';
import 'package:hey_rajat/Utils/utils.dart';

class Notes extends StatefulWidget {
  String uid;
  Notes({super.key, required this.uid});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<dynamic> notesList = [];
  bool isload = true;
  String password = "";

  TextEditingController newpassword = TextEditingController();
  TextEditingController reenternewpassword = TextEditingController();
  TextEditingController verifypassword = TextEditingController();
  TextEditingController previouspassword = TextEditingController();
  TextEditingController changepasswordpassword = TextEditingController();
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  void getdata(String documentId) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        notesList = snapshot.get("mynote");
        setState(() {
          password = snapshot.get("password");
          isload = false;
        });
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
            getdata(documentId);
          });
        } else {
          print("Invalid index");
        }
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

  void updatepassword(
      String documentId, String password, int index, bool newLockValue) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
    DocumentReference docRef = colRef.doc(documentId);

    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        String pas = snapshot.get("password");
        pas = password;
        await docRef
            .set({"password": pas}, SetOptions(merge: true)).whenComplete(() {
          updatedata(documentId, index, newLockValue);
          Navigator.pop(context);
        });
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
  void initState() {
    super.initState();
    getdata(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Write your Notes",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notesList.isEmpty
              ? const Center(
                  child: Text("No notes found"),
                )
              : ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Text(
                              notesList[index]['title'][0]
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          tileColor: Colors.deepPurple,
                          shape: const StadiumBorder(
                              side: BorderSide(color: Colors.white)),
                          onTap: () {
                            if (notesList[index]['lock'] == true) {
                              passwordverification(index, 1);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotesData(
                                            date: notesList[index]['date'],
                                            lock: notesList[index]['lock'],
                                            thought: notesList[index]
                                                ['thought'],
                                            title: notesList[index]['title'],
                                            index: index,
                                            uid: widget.uid,
                                          ))).then((value) {
                                if (value == "yes") {
                                  getdata(widget.uid);
                                }
                              });
                            }
                          },
                          title: Text(
                            notesList[index]['title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            notesList[index]['thought'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              notesList[index]['lock']
                                  ? const Icon(
                                      Icons.lock,
                                      color: Colors.red,
                                    )
                                  : const SizedBox(),
                              PopupMenuButton(
                                color: Colors.white,
                                onSelected: (value) {
                                  if (value == 1) {
                                    if (password == "") {
                                      newpassword.clear();
                                      reenternewpassword.clear();
                                      createpassword(index);
                                    } else {
                                      if (notesList[index]['lock'] == false) {
                                        updatedata(widget.uid, index, true);
                                      }
                                    }
                                  } else if (value == 2) {
                                    if (notesList[index]['lock'] == true) {
                                      verifypassword.clear();
                                      passwordverification(index, 2);
                                    }
                                  } else if (value == 3) {
                                    if (password == "") {
                                      newpassword.clear();
                                      reenternewpassword.clear();
                                      createpassword(index);
                                    } else {
                                      previouspassword.clear();
                                      changepasswordpassword.clear();
                                      changepassword(index);
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Lock",
                                      )),
                                  const PopupMenuItem(
                                      value: 2,
                                      child: Text(
                                        "Remove Lock",
                                      )),
                                  const PopupMenuItem(
                                      value: 3,
                                      child: Text(
                                        "Change password",
                                      ))
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateNote(
                          title: "",
                          thought: "",
                          from: "new",
                          index: 0,
                          uid: widget.uid,
                        ))).then((value) {
              if (value == "yes") {
                getdata(widget.uid);
              }
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  createpassword(int index) {
    return showDialog(
      context: context,
      builder: (tt) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Create your Password",
                  style: const TextStyle(
                      // color: AppColors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _FormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: newpassword,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //add prefix icon

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "Enter your new Password",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'New Password',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: reenternewpassword,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "Re-Enter your new Password",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'Re-Enter new Password',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter password';
                          }
                          if (newpassword.text.trim() !=
                              reenternewpassword.text.trim()) {
                            return 'Enter password are not same';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValidForm = _FormKey.currentState!.validate();
                    if (isValidForm) {
                      if (newpassword.text == reenternewpassword.text) {
                        updatepassword(
                            widget.uid, newpassword.text, index, true);
                      }
                    }
                  },
                  child: Text("Create Password"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    newpassword.clear();
                    reenternewpassword.clear();
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), backgroundColor: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  changepassword(int index) {
    return showDialog(
      context: context,
      builder: (tt) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Change your Password",
                  style: const TextStyle(
                      // color: AppColors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _FormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: previouspassword,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "Enter your Previous Password",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'Previous Password',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter password';
                          }
                          if (password != previouspassword.text) {
                            return 'your previous password is wrong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: changepasswordpassword,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //add prefix icon

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "Enter your new Password",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'New Password',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValidForm = _FormKey.currentState!.validate();
                    if (isValidForm) {
                      if (previouspassword.text == password) {
                        updatepassword(widget.uid, changepasswordpassword.text,
                            index, notesList[index]['lock']);
                        // Navigator.pop(context);
                      }
                    }
                  },
                  child: Text("Change Password"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    previouspassword.clear();
                    changepasswordpassword.clear();
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), backgroundColor: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  passwordverification(int index, int check) {
    return showDialog(
      context: context,
      builder: (tt) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Enter your Password",
                  style: const TextStyle(
                      // color: AppColors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _FormKey,
                  child: TextFormField(
                    controller: verifypassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      //add prefix icon

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,

                      hintText: "Enter your Password",

                      //make hint text
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),

                      //create lable
                      labelText: 'Enter Password',
                      //lable style
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter password';
                      }
                      if (value.toString() != password) {
                        return 'Please Enter correct password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValidForm = _FormKey.currentState!.validate();
                    if (isValidForm) {
                      if (password == verifypassword.text.trim()) {
                        if (check == 1) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesData(
                                        date: notesList[index]['date'],
                                        lock: notesList[index]['lock'],
                                        thought: notesList[index]['thought'],
                                        title: notesList[index]['title'],
                                        index: index,
                                        uid: widget.uid,
                                      ))).then((value) {
                            if (value == "yes") {
                              getdata(widget.uid);
                            }
                          });
                        } else {
                          updatedata(widget.uid, index, false);
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: Text(check == 1 ? "Open" : "Remove lock"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    verifypassword.clear();
                  },
                  child: Text("Close"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), backgroundColor: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}