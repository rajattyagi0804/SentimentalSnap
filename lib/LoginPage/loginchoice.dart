import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hey_rajat/LoginPage/loginPage.dart';

class LoginAsUserOrAdmin extends StatelessWidget {
  const LoginAsUserOrAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  "Choose your Role",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/new.jpg"),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(role: "Admin")));
                        },
                        child: Text("Admin"),
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.indigo,
                            minimumSize: Size(200, 50)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                        role: "User",
                                      )));
                        },
                        child: Text("User"),
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.amber,
                            minimumSize: Size(150, 50)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
