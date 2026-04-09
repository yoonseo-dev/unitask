import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 15,
      children: [
        Expanded(child: Divider()),
        Text('또는', style: TextStyle(color: Colors.grey)),
        Expanded(child: Divider()),
      ],
    );
  }
}
