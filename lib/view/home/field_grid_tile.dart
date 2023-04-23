import 'package:flutter/material.dart';

class FieldGridTile extends StatelessWidget {
  final String fieldName;
  final Function() onTap;

  const FieldGridTile({
    super.key,
    required this.fieldName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        footer: Text(fieldName),
        child: Icon(
          Icons.map,
          size: 80,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
