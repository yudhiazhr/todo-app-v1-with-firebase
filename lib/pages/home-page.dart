import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/add-todo-page.dart';
import 'package:todo_app_firebase/pages/view-data.dart';
import 'package:todo_app_firebase/services/auth-services.dart';
import 'dart:async';

import 'package:todo_app_firebase/widgets/todo-card.dart';

import 'auth/login-page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class SelectedCard {
  String? id;
  bool? checkValue = false;

  SelectedCard({this.id, this.checkValue});
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  late Stream<DateTime> _dateTimeStream;
  late DateTime _currentTime;
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<SelectedCard> selected = [];

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
    void onChange(int index) {
      setState(() {
        selected[index].checkValue = !selected[index].checkValue!;
      });
    }

    bool isAnyCardChecked() {
      return selected.any((card) => card.checkValue == true);
    }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Text(
                          formattedTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (isAnyCardChecked())
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () async {
                              await QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                text: 'Are you sure want to delete?',
                                showConfirmBtn: true,
                                showCancelBtn: true,
                                confirmBtnText: "Yes",
                                cancelBtnText: "Cancel",
                                confirmBtnColor:
                                    Color.fromARGB(255, 75, 150, 131),
                                onConfirmBtnTap: () {
                                  for (int i = 0; i < selected.length; i++) {
                                    if (selected[i].checkValue == true) {
                                      FirebaseFirestore.instance
                                          .collection("Todo")
                                          .doc(selected[i].id)
                                          .delete()
                                          .then((value) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text:
                                              'Selected tasks have been deleted',
                                          confirmBtnColor:
                                              Color.fromARGB(255, 75, 150, 131),
                                        );
                                      });
                                    }
                                  }
                                  Get.back();
                                },
                                onCancelBtnTap: () {
                                  Get.back();
                                },
                              );
                              Get.off(() => HomePage());
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          preferredSize: Size.fromHeight(40),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: StreamBuilder(
              stream: _stream,
              builder: (contex, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No tasks planned.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Poppins",
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    IconData iconData;
                    Color iconColor;
                    Color iconBgColor;
                    Map<String, dynamic> documents = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
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
                    selected.add(SelectedCard(
                        id: snapshot.data!.docs[index].id, checkValue: false));
                    return InkWell(
                      onTap: () {
                        Get.to(() => ViewData(
                              document: documents,
                              id: snapshot.data!.docs[index].id,
                            ));
                      },
                      child: TodoCard(
                        title: documents["title"],
                        iconData: iconData,
                        iconColor: iconColor,
                        iconBgColor: iconBgColor,
                        time: "17 pm",
                        check: selected[index].checkValue!,
                        index: index,
                        onChange: onChange,
                      ),
                    );
                  },
                );
              })),
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
                Get.to(() => AddTodoPage(),
                    transition: Transition.downToUp,
                    duration: Duration(milliseconds: 600));
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
                    confirmBtnColor: Color.fromARGB(255, 75, 150, 131),
                    title: "Logout",
                    text: "Are you sure?\nDo you want to logout from the app?",
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
            label: '',
          ),
        ],
      ),
    );
  }
}
