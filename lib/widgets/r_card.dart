import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const RCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
        ),
        child: child,
      );
}
