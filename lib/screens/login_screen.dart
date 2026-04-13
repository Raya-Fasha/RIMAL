import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  const LoginScreen({super.key, required this.state, required this.t});

  @override
  Widget build(BuildContext context) {
    final roles = t['login_roles'] as List;
    return RimalScaffold(
      state: state,
      t: t,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 16),
          const Text('Rimal',
              style: TextStyle(
                  color: C.textPrim,
                  fontWeight: FontWeight.w900,
                  fontSize: 28)),
          const SizedBox(height: 8),
          Text(t['login_sub'],
              style: const TextStyle(color: C.textMut, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Role selector
              Text(t['login_role_label'],
                  style: const TextStyle(
                      color: C.textDim,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 10),
              Row(
                children: roles.map<Widget>((r) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: r == roles.last ? 0 : 8),
                      child: _RoleCard(
                        label:    r['label'],
                        desc:     r['desc'],
                        isActive: state.loginRole == r['key'],
                        onTap:    () => state.setLoginRole(r['key']),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Sanad button
              _SanadBtn(
                label: t['login_sanad'],
                onTap: state.doLogin,
              ),
              const SizedBox(height: 14),

              // Verified by Sanad notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF002040),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: C.border),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: Color(0xFF2DA84A), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${t['login_sanad_by']} ',
                                      style: const TextStyle(
                                          color: C.textMut, fontSize: 12)),
                                  TextSpan(
                                      text: t['login_sanad_name'],
                                      style: const TextStyle(
                                          color: C.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ]),
                              ),
                              const SizedBox(height: 2),
                              Text(t['login_sanad_sub'],
                                  style: const TextStyle(
                                      color: C.textDim, fontSize: 11)),
                            ]),
                      ),
                    ]),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(t['login_trouble'],
                    style: const TextStyle(
                        color: C.textMut,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: C.textMut)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _SanadLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2DA84A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.62)
      ..cubicTo(size.width * 0.15, size.height * 0.62,
          size.width * 0.28, size.height * 0.48,
          size.width * 0.38, size.height * 0.44)
      ..cubicTo(size.width * 0.45, size.height * 0.41,
          size.width * 0.52, size.height * 0.44,
          size.width * 0.58, size.height * 0.42)
      ..cubicTo(size.width * 0.66, size.height * 0.4,
          size.width * 0.72, size.height * 0.34,
          size.width * 0.8, size.height * 0.24);
    canvas.drawPath(path, paint);
    final arrow = Paint()
      ..color = const Color(0xFF2DA84A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final arrowPath = Path()
      ..moveTo(size.width * 0.68, size.height * 0.22)
      ..lineTo(size.width * 0.8, size.height * 0.24)
      ..lineTo(size.width * 0.78, size.height * 0.36);
    canvas.drawPath(arrowPath, arrow);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Role selector card with hover animation ────────────────────────────────

class _RoleCard extends StatefulWidget {
  final String label;
  final String desc;
  final bool isActive;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.desc,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve:    Curves.easeOut,
          padding:  const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF002040)
                : (_hovered ? const Color(0xFF001830) : C.bg),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? C.blue
                  : (_hovered ? C.borderHi : C.border),
            ),
            boxShadow: _hovered && !active
                ? [
                    BoxShadow(
                      color:      C.blue.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset:     const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color:      active ? C.blue : (_hovered ? C.textPrim : C.textMut),
                  fontSize:   14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.desc,
                style: const TextStyle(
                  color:  C.textDim,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sanad sign-in button with hover animation ──────────────────────────────

class _SanadBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SanadBtn({required this.label, required this.onTap});

  @override
  State<_SanadBtn> createState() => _SanadBtnState();
}

class _SanadBtnState extends State<_SanadBtn> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTap:       widget.onTap,
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        child: AnimatedScale(
          scale:    _pressed ? 0.97 : (_hovered ? 1.015 : 1.0),
          duration: const Duration(milliseconds: 140),
          curve:    Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve:    Curves.easeOut,
            padding:  const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color:        _hovered ? const Color(0xFFF2F2F2) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border:       Border.all(
                color: _hovered ? const Color(0xFFCCCCCC) : Colors.white,
              ),
              boxShadow: [
                BoxShadow(
                  color:      Colors.black.withValues(alpha: _hovered ? 0.12 : 0.06),
                  blurRadius: _hovered ? 14 : 4,
                  offset:     _hovered ? const Offset(0, 4) : Offset.zero,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width:  36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:      Colors.black.withValues(alpha: 0.10),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: CustomPaint(painter: _SanadLogoPainter()),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color:      Color(0xFF1A1A1A),
                    fontSize:   15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
