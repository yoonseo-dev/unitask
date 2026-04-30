import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar(String text, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: .floating,
        backgroundColor: isError ? Colors.red : null,
        content: Text(text, style: TextStyle(fontWeight: .bold)),
      ),
    );
  }
}
