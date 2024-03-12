import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/home-page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          Get.off(() => HomePage());
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
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        print("Cancel to Sign In");
      }
      ;
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(e.toString()),
      );
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    // Write value
    await storage.write(
        key: 'token', value: userCredential.credential!.token.toString());
    await storage.write(
        key: 'userCredential', value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Get.off(() => HomePage());
      
      print(userCredential.user!.email);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sign In Success',
        confirmBtnColor: Color.fromARGB(255, 75, 150, 131),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
