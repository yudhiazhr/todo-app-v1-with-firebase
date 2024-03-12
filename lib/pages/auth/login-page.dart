import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/auth/phone-auth-page.dart';
import 'package:todo_app_firebase/pages/auth/sign-up-page.dart';
import 'package:todo_app_firebase/pages/home-page.dart';
import 'package:todo_app_firebase/services/auth-services.dart';
import 'package:todo_app_firebase/widgets/button-auth.dart';
import 'package:todo_app_firebase/widgets/input-field.dart';
import 'package:todo_app_firebase/widgets/pass-input-field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  AuthClass authClass = AuthClass();

   bool spinner = false;

  void signIn() async {
    try {
      firebase_auth.UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      Get.off(() => HomePage());

      print(userCredential.user!.email);

      setState(() {
        spinner = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sign In Success',
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
      backgroundColor: Colors.black,
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sign In",
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
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Or",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              ButtonAuth(
                onTap: () async {
                  await authClass.googleSignIn(context);
                },
                  imagePath: "assets/google.svg",
                  buttonName: "Continue with Google",
                  size: 25),
              ButtonAuth(
                onTap: () {
                  Get.to(() => PhoneAuthPage());
                },
                  imagePath: "assets/phone.svg",
                  buttonName: "Continue with Phone Number",
                  size: 25),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
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
                  Text("Don't have an Account?", style: TextStyle(
                    color: Colors.white
                  ),),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignUpPage());
                    },
                    child: Text("Sign Up", style: TextStyle(
                    color: Color.fromARGB(255, 75, 150, 131),fontWeight: FontWeight.bold,
                  ) ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
