import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final Color? color;

  const ConfirmationButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.tertiary;

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: color ?? defaultColor,
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
