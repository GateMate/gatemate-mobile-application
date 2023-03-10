import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ConfirmationButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;

  const ConfirmationButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: HexColor('#44564a'),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
