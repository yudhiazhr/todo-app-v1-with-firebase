import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:todo_app_firebase/services/auth-services.dart';
import 'login-page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  int start = 180;
  bool wait = false;
  String buttonName = "Send";
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    print("build");

    void startTimer() {
      const onsec = Duration(seconds: 1);
      _timer = Timer.periodic(onsec, (timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            wait = false;
          });
        } else {
          setState(() {
            start--;
          });
        }
      });
    }

    void setData(verificationId) {
      setState(() {
        verificationIdFinal = verificationId;
      });
      startTimer();
    }

    Widget otpField() {
      return OTPTextFieldV2(
        length: 6,
        width: MediaQuery.of(context).size.width - 12,
        fieldWidth: 48,
        otpFieldStyle: OtpFieldStyle(
            backgroundColor: Colors.grey.shade900, borderColor: Colors.white),
        style: TextStyle(fontSize: 17, color: Colors.white),
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.underline,
        onCompleted: (pin) {
          print("Completed: " + pin);
          setState(() {
            smsCode = pin;
          });
        },
      );
    }

    @override
    void dispose() {
      _timer!.cancel();
      super.dispose();
    }

    return Scaffold(
            backgroundColor: Color(0xff070F2B),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              setState(() {
                _timer?.cancel();
                wait = false;
              });
              Get.off(() => LoginPage());
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color.fromARGB(255, 75, 150, 131),
                  controller: phoneNumberController,
                  validator: (value) {
                    RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)');
                    if (value!.isEmpty) {
                      return "Phone Number Cannot Be Empty";
                    } else if (!regex.hasMatch(value)) {
                      return 'Please Enter Valid Phone Number (Min. 11 Character)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumberController.text = value!;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 75, 150, 131)),
                    ),
                    fillColor: Colors.grey.shade900,
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 15),
                      child: Text(
                        " (+62) ",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 15),
                      child: InkWell(
                          onTap: wait
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    startTimer();
                                    setState(() {
                                      start = 180;
                                      wait = true;
                                      buttonName = "Resend";
                                    });
                                    await authClass.verifyPhoneNumber(
                                        "+62 ${phoneNumberController.text}",
                                        context,
                                        setData);
                                  }
                                },
                          child: Text(
                            buttonName,
                            style: TextStyle(
                              color: wait
                                  ? Colors.grey
                                  : Color.fromARGB(255, 75, 150, 131),
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    hintText: "Enter your phone number",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade900,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text(
                      "Enter 6 digit OTP",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              otpField(),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "OTP will be send again in ",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                TextSpan(
                  text: "${(start ~/ 60).toString().padLeft(2, '0')}:"
                      "${(start % 60).toString().padLeft(2, '0')} ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "sec",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ]))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: InkWell(
          onTap: () {
            authClass.signInwithPhoneNumber(
                verificationIdFinal, smsCode, context);
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 150, 131),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "Lets Go",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
