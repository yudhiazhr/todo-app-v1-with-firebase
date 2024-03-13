import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/auth/login-page.dart';
import 'package:todo_app_firebase/pages/home-page.dart';
import 'package:todo_app_firebase/widgets/input-field.dart';
import 'package:todo_app_firebase/widgets/pass-input-field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameEditingController =
      TextEditingController();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  bool spinner = false;

  void signUp() async {
    try {
      firebase_auth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      Get.offAll(() => HomePage());

      print(userCredential.user!.email);

      setState(() {
        spinner = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sign Up Success',
        confirmBtnColor: Color.fromARGB(255, 75, 150, 131),
      );
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      setState(() {
        spinner = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          spinner = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070F2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.to(() => LoginPage());
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                /* InputField(
                  controller: userNameEditingController,
                  name: "Username",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("User name Cannot Be Empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid User name(Min. 3 Character)");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userNameEditingController.text = value!;
                  },
                ), */
                SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: emailController,
                  name: "Email",
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    if (!RegExp("^[a-zA-z0-9+_.-]+@[[a-zA-z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                PassInputField(
                  controller: passwordController,
                  name: "Password",
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                  ),
                  obscureText: true,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Password is required for login");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid Password(Min. 6 Character)");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 75, 150, 131),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: spinner
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => LoginPage());
                      },
                      child: Text("Sign In",
                          style: TextStyle(
                            color: Color.fromARGB(255, 75, 150, 131),
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
