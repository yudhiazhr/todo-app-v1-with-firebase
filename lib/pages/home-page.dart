import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_firebase/pages/add-todo-page.dart';
import 'dart:async';

import 'package:todo_app_firebase/widgets/todo-card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<DateTime> _dateTimeStream;
  late DateTime _currentTime;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TodoCard(
                  title: "Lets go GYM",
                  iconData: Icons.sports_gymnastics_outlined,
                  iconColor: Colors.white,
                  iconBgColor: Colors.black,
                  time: "11 PM",
                  check: false),
              TodoCard(
                  title: "Wake up",
                  iconData: Icons.alarm,
                  iconColor: Colors.red,
                  iconBgColor: Colors.white,
                  time: "7 AM",
                  check: true),
              TodoCard(
                  title: "Go to the shop",
                  iconData: Icons.shopping_cart,
                  iconColor: Colors.white,
                  iconBgColor: Colors.orangeAccent,
                  time: "19 PM",
                  check: false),
            ],
          ),
        ),
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
            icon: Icon(Icons.settings, size: 32, color: Colors.white),
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