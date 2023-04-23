import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 40,
      thickness: 2,
      color: Colors.black,
    );
  }
}
