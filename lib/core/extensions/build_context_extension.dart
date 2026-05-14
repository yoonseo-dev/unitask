import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
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
