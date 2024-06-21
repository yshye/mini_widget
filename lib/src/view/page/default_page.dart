import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final Widget child;
  final String title;

  const DefaultPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
