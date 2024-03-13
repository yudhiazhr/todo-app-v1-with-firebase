import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final dynamic validator;
  final TextEditingController controller;
  final String name;
  final dynamic prefixIcon;
  final dynamic onSaved;

  InputField(
      {required this.controller,
      required this.name,
      required this.prefixIcon,
      required this.validator,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Color.fromARGB(255, 75, 150, 131),
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color.fromARGB(255, 75, 150, 131)),
          ),
          fillColor: Color(0xff2a2e3d),
          filled: true,
          prefixIcon: prefixIcon,
          hintText: name,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
