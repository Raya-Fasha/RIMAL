import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RLabel extends StatelessWidget {
  final String text;
  const RLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: C.textDim,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8),
        ),
      );
}
