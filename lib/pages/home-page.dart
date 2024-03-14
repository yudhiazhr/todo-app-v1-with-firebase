import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/add-todo-page.dart';
import 'package:todo_app_firebase/services/auth-services.dart';
import 'dart:async';

import 'package:todo_app_firebase/widgets/todo-card.dart';

import 'auth/login-page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  late Stream<DateTime> _dateTimeStream;
  late DateTime _currentTime;
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection("Todo").snapshots();

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _dateTimeStream = Stream<DateTime>.periodic(Duration(seconds: 1), (index) {
      return DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070F2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 26,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/ava-2.png'),
            ),
          )
        ],
        bottom: PreferredSize(
          child: StreamBuilder<DateTime>(
            stream: _dateTimeStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _currentTime = snapshot.data!;
              }
              String formattedTime =
                  "${DateFormat('EEEE').format(_currentTime)}, ${_currentTime.day} ${DateFormat('MMMM').format(_currentTime)}";
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
          preferredSize: Size.fromHeight(25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: StreamBuilder(
                stream: _stream, 
                builder: (contex, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      IconData iconData;
                      Color iconColor;
                      Color iconBgColor;
                      Map<String, dynamic> documents = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      switch (documents["category"]) {
                        case "Work":
                          iconData = Icons.work;
                          iconColor = Colors.black;
                          iconBgColor = Colors.white;
                          break;
                        case "WorkOut":
                          iconData = Icons.sports_gymnastics_outlined;
                          iconColor = Colors.white;
                          iconBgColor = Colors.black;
                          break;
                        case "Food":
                          iconData = Icons.local_grocery_store_rounded;
                          iconColor = Colors.white;
                          iconBgColor = Colors.orangeAccent;
                          break;
                        case "Design":
                          iconData = Icons.design_services;
                          iconColor = Colors.white;
                          iconBgColor = Colors.teal;
                          break;
                        default:
                          iconData = Icons.run_circle_outlined;
                          iconColor = Colors.red;
                          iconBgColor = Colors.white;
                      }
                      return TodoCard(
                        title: documents["title"], 
                        iconData: iconData, 
                        iconColor: iconColor, 
                        iconBgColor: iconBgColor, 
                        time: "17 pm", 
                        check: true);
                    },
                  );
                }
              )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff070F2B),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 32, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Get.to(() => AddTodoPage(), transition: Transition.downToUp , duration: Duration(milliseconds: 600));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 75, 150, 131),
                      Colors.indigoAccent
                    ])),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
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
              )) ,
            label: '',
          ),
        ],
      ),
    );
  }
}


 /* IconButton(
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
              )) */