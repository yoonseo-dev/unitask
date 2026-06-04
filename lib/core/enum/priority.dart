import 'package:flutter/material.dart';

enum Priority { high, medium, low }

extension PriorityExtension on Priority {
  Color get primary => switch (this) {
    .high => Colors.red,
    .medium => Colors.amber,
    .low => Colors.green,
  };
  Color get secondary => switch (this) {
    .high => Color(0xfffee2e2),
    .medium => Color(0xfffef3c7),
    .low => Color(0xffdcfce7),
  };
  //다국어 지원시 il8n 연결하기
  String get title => switch (this) {
    .high => '높음',
    .medium => '중간',
    .low => '낮음',
  };
}
