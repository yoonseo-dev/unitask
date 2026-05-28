//테스크 속 글자 길이가 길어지면?
import 'package:flutter/material.dart';

class SubjectLabel extends StatelessWidget {
  final String text;

  const SubjectLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: .circular(6),
      ),
      child: Text(text, style: TextStyle(fontWeight: .w700, fontSize: 12)),
    );
  }
}
