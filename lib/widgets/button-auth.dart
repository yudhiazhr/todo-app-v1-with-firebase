import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class ButtonAuth extends StatelessWidget {
  final String imagePath;
  final String buttonName;
  final double size;
  final VoidCallback  onTap;

  ButtonAuth(
      {required this.imagePath, required this.buttonName, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {



    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Color(0xff2a2e3d),
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide.none),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
