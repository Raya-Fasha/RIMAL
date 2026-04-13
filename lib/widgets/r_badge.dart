import 'package:flutter/material.dart';

class RBadge extends StatelessWidget {
  final String label;
  final Color bg, fg;

  const RBadge({super.key, required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(label,
            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}
