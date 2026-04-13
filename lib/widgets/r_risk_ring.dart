import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RRiskRing extends StatefulWidget {
  final int score;
  const RRiskRing({super.key, required this.score});

  @override
  State<RRiskRing> createState() => _RRiskRingState();
}

class _RRiskRingState extends State<RRiskRing>
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
  void didUpdateWidget(RRiskRing oldWidget) {
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _RiskRingPainter(
              progress: _animation.value,
              color: c,
              bgColor: C.border,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.score}',
                    style: const TextStyle(
                      color: C.textPrim,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '/ 100',
                    style: const TextStyle(
                      color: C.textDim,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RiskRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _RiskRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Background circle
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start at top
    final sweepAngle = 2 * 3.14159 * progress; // Full circle based on progress

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RiskRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.bgColor != bgColor;
  }
}
