import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/pages/auth/login-page.dart';
import 'package:todo_app_firebase/pages/home-page.dart';
import 'package:todo_app_firebase/services/auth-services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  Widget currentPage = LoginPage();
  AuthClass authClass = AuthClass();

  @override
  void  initState() {
    super.initState();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if(token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 75, 150, 131),
      ),
      title: 'Todo app firebase',
      home: currentPage,
    );
  }
}
