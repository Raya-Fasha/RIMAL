import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RScoreBar extends StatefulWidget {
  final int score;
  const RScoreBar({super.key, required this.score});

  @override
  State<RScoreBar> createState() => _RScoreBarState();
}

class _RScoreBarState extends State<RScoreBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100)
        .animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(RScoreBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: _animation.value, end: widget.score / 100)
          .animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.score >= 61
        ? C.red
        : widget.score >= 31
            ? C.orange
            : C.green;
    return Container(
      height: 6,
      decoration: BoxDecoration(
          color: C.border, borderRadius: BorderRadius.circular(999)),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FractionallySizedBox(
            widthFactor: _animation.value,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: c, borderRadius: BorderRadius.circular(999)),
            ),
          );
        },
      ),
    );
  }
}
