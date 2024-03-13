import 'package:flutter/material.dart';

class PassInputField extends StatelessWidget {
  final String name;
  final dynamic validator;
  final dynamic prefixIcon;
  final TextEditingController controller;
  final dynamic onSaved;
  final bool obscureText;

  PassInputField({
    required this.controller,
    required this.onSaved,
    required this.name,
    required this.validator,
    this.prefixIcon,
    this.obscureText = false,
  });
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
          obscureText: obscureText,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color.fromARGB(255, 75, 150, 131)),
            ),
            fillColor: Color(0xff2a2e3d),
            filled: true,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none
            ),
            hintText: name,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
    );
  }
}
