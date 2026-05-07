import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('내 과제', style: TextStyle(fontWeight: .bold)),
          actions: [IconButton(onPressed: () {}, icon: Icon(LucideIcons.bell))],
        ),
        body: SafeArea(child: Placeholder()),
      ),
    );
  }
}
