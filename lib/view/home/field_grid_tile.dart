import 'package:flutter/material.dart';

class FieldGridTile extends StatelessWidget {
  final String fieldName;
  final bool isSelection;
  final Function() onTap;

  const FieldGridTile({
    super.key,
    required this.fieldName,
    required this.isSelection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = 20.0;
    final theme = Theme.of(context);
    final tileStyle = _getTileStyle(isSelection, theme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tileStyle.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: GridTile(
          footer: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tileStyle.primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(borderRadius),
              ),
            ),
            child: Text(
              fieldName,
              style: TextStyle(
                color: tileStyle.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: Icon(
            Icons.map,
            size: 80,
            color: tileStyle.primaryColor,
          ),
        ),
      ),
    );
  }

  FieldGridTileStyle _getTileStyle(bool isSelection, ThemeData theme) {
    if (isSelection) {
      return FieldGridTileStyle(
        primaryColor: theme.colorScheme.primary,
        secondaryColor: theme.cardColor,
        textColor: theme.colorScheme.onPrimary,
      );
    } else {
      return FieldGridTileStyle(
        primaryColor: theme.colorScheme.tertiary,
        secondaryColor: Colors.white70,
        textColor: theme.colorScheme.onTertiary,
      );
    }
  }
}

class FieldGridTileStyle {
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;

  FieldGridTileStyle({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });
}
