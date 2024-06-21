import 'package:flutter/material.dart';

class MiniButton extends StatelessWidget {
  const MiniButton({
    super.key,
    this.text = '',
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
