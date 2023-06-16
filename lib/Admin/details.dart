import 'package:flutter/material.dart';

class UserDetailsinAdminView extends StatefulWidget {
  String uid, email, notespassword, usertoken;
  UserDetailsinAdminView(
      {super.key,
      required this.uid,
      required this.email,
      required this.notespassword,
      required this.usertoken});

  @override
  State<UserDetailsinAdminView> createState() => _UserDetailsinAdminViewState();
}

class _UserDetailsinAdminViewState extends State<UserDetailsinAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.email
                  .toString()
                  .replaceAll('@gmail.com', '')[0]
                  .toUpperCase() +
              widget.email.toString().replaceAll('@gmail.com', '').substring(1),
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                border: TableBorder
                    .all(), // Allows to add a border decoration around your table
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'User',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5),
                          child: Text(
                            widget.email
                                    .toString()
                                    .replaceAll('@gmail.com', '')[0]
                                    .toUpperCase() +
                                widget.email
                                    .toString()
                                    .replaceAll('@gmail.com', '')
                                    .substring(1),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ]),
                  TableRow(children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(
                        'Email',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(widget.email),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(
                        'Uid',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(widget.uid),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                      child: Text(
                        'Token',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(widget.uid),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Text(
                        'Notes Password',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: widget.notespassword != ""
                          ? Text(widget.notespassword)
                          : Text(
                              "Not Created Yet",
                              style: TextStyle(color: Colors.red),
                            ),
                    ),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}
