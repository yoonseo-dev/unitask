import 'package:flutter/material.dart';
import 'package:unitask/app/theme/preview.dart';
import 'package:unitask/core/enum/priority.dart';

@AppThemePreview(group: 'Badge', name: '우선순위')
Widget preview() => Wrap(
  spacing: 10,
  runSpacing: 10,
  children: [
    PriorityBadge(priority: .high),
    PriorityBadge(priority: .medium),
    PriorityBadge(priority: .low),
  ],
);

class PriorityBadge extends StatelessWidget {
  final Priority priority;
  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priority.secondary,
        borderRadius: .circular(50),
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: .min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: .circle, color: priority.primary),
          ),
          Text(
            priority.title,
            style: TextStyle(
              color: priority.primary,
              fontSize: 12,
              fontWeight: .w700,
            ),
          ),
        ],
      ),
    );
  }
}
