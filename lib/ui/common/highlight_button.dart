import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:unitask/app/theme/preview.dart';

@AppThemePreview(group: 'Buttons', name: 'HighlightButton')
Widget preview() => Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    HighlightButton(
      leading: Icon(LucideIcons.plus, size: 14),
      //trailing: Icon(LucideIcons.plus, size: 14),
      child: Text('새 과제 추가'),
    ),
  ],
);

class HighlightButton extends StatelessWidget {
  final Color color;
  final double spacing;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;

  const HighlightButton({
    super.key,
    this.color = Colors.blue,
    this.spacing = 10.0,
    required this.child,
    this.leading,
    this.trailing,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: .symmetric(vertical: 5, horizontal: 14),
        decoration: BoxDecoration(
          border: .all(color: color, width: 2),
          borderRadius: .circular(10),
          color: color.withValues(alpha: 0.3),
        ),
        alignment: .center,
        child: Row(
          spacing: spacing,
          mainAxisSize: .min,
          children: [
            if (leading != null && leading is Icon)
              Icon(
                (leading as Icon).icon,
                color: (leading as Icon).color ?? color,
                size: (leading as Icon).size,
              ),
            DefaultTextStyle(
              style: TextStyle(fontWeight: .bold, color: color),
              child: child,
            ),
            if (trailing != null && trailing is Icon)
              Icon(
                (trailing as Icon).icon,
                color: (trailing as Icon).color ?? color,
                size: (trailing as Icon).size,
              ),
          ],
        ),
      ),
    );
  }
}
