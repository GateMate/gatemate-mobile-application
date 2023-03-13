import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  // final HexColor

  const CustomInputField({
    super.key,
    required this.inputController,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    // this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.white70,
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
