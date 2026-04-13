import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RSectionLabel extends StatelessWidget {
  final String text;
  const RSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            color: C.blue,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
      );
}
