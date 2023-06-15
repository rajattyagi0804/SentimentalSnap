import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/dashboard.dart';
import 'package:hey_rajat/HomeScreen/notes.dart';

class BottomNav extends StatefulWidget {
  String uid, email, role;
  BottomNav(
      {super.key, required this.uid, required this.email, required this.role});

  @override
  State<BottomNav> createState() => _BottomNavstate();
}

class _BottomNavstate extends State<BottomNav> {
  int myIndex = 0;

  late List tab = [
    DashboardScreen(
      uid: widget.uid.toString(),
      email: widget.email.toString(),
      role: widget.role,
    ),
    Notes(
      uid: widget.uid.toString(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tab[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.memory_rounded),
              label: "Moments",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: "Notes",
            ),
          ]),
    );
  }
}
