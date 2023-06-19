import 'package:flutter/material.dart';
import 'package:hey_rajat/HomeScreen/dashboard.dart';
import 'package:hey_rajat/HomeScreen/notes.dart';
import 'package:hey_rajat/HomeScreen/profile.dart';

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
      role: widget.role,
    ),
    Profile(
      role: widget.role,
      email: widget.email.toString(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tab[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          useLegacyColorScheme: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.indigo,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.yellow),
          unselectedIconTheme: IconThemeData(color: Colors.white),
          showSelectedLabels: true,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/camera.jpeg',
                width: 25,
                height: 25,
              ),
              label: "Moments",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/dairyimage.png',
                width: 25,
                height: 25,
              ),
              label: "Dairy",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ]),
    );
  }
}
