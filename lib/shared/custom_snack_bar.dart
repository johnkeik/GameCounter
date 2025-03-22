import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
  }) {
    // Define colors and icons based on the type
    final Color backgroundColor;
    final Color textColor;
    final IconData icon;

    if (type == SnackBarType.success) {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[900]!;
      icon = Icons.check_circle_outline;
    } else {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[900]!;
      icon = Icons.error_outline;
    }

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Enum to specify the type of SnackBar
enum SnackBarType { success, error }
