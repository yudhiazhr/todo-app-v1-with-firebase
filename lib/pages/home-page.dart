import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:quickalert/quickalert.dart";
import "package:todo_app_firebase/pages/auth/login-page.dart";
import "package:todo_app_firebase/services/auth-services.dart";


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  confirmBtnText: "Yes",
                  cancelBtnText: "Cancel",
                  showCancelBtn: true,
                  showConfirmBtn: true,
                  onCancelBtnTap: () => Get.back(),
                  onConfirmBtnTap: () async {
                    await authClass.signOut(context);
                    Get.offAll(() => LoginPage());
                  },
                  confirmBtnColor: Colors.orangeAccent,
                  title: "Logout",
                  text: "Are you sure?\nDo you want to logout from the app?",
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
          child: Text(
        "Home Page",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
