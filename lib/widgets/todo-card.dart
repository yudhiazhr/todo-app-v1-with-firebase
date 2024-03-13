import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;

  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.iconBgColor,
      required this.time,
      required this.check})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: Color.fromARGB(255, 75, 150, 131),
                checkColor: Colors.white,
                value: check,
                onChanged: (bool? value) {},
              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color.fromARGB(255, 199, 204, 219),
            ),
          ),
          Expanded(
              child: Container(
            height: 75,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xff2a2e3d),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: iconBgColor),
                    child: Icon(iconData, color: iconColor,),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey,
                        fontWeight: FontWeight.w100,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
