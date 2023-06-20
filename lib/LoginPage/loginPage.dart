import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey_rajat/Auth/auth.dart';
import 'package:hey_rajat/Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;

  bool isload = false;
  String? errormessage = "";
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  Future<void> signInwithEmailandPassword() async {
    try {
      await Auth().signInWithEmailandPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
        context: context,
      );
    } on FirebaseAuthException catch (e) {
      errormessage = e.message;
      Utils.show_Simple_Snackbar(context, errormessage);
      setState(() {
        isload = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/logimage.jpg"),
                      fit: BoxFit.fill),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _FormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // for login
                    TextFormField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        //add prefix icon
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.grey,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,

                        hintText: "Email/Mobile",

                        //make hint text
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: 'Email/Mobile',
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
                          return 'Enter Email id';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // for password

                    TextFormField(
                      controller: _passwordcontroller,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        focusColor: Colors.white,

                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          child: Icon(
                            !_isHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,

                        hintText: "Password",

                        //make hint text
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: 'Password',
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
                          return 'Enter correct password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final isValidForm = _FormKey.currentState!.validate();
                        if (isValidForm) {
                          signInwithEmailandPassword();
                          setState(() {
                            isload = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          shape: const StadiumBorder(),
                          minimumSize: const Size(120, 40)),
                      child: isload
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              "Log In",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
