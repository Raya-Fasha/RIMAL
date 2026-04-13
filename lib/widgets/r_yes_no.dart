import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RYesNo extends StatelessWidget {
  final bool? value;
  final String yesLabel;
  final String noLabel;
  final ValueChanged<bool> onChanged;

  const RYesNo({
    super.key,
    required this.value,
    required this.yesLabel,
    required this.noLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        _YesNoOption(
          label:     yesLabel,
          opt:       true,
          active:    value == true,
          onChanged: onChanged,
        ),
        const SizedBox(width: 8),
        _YesNoOption(
          label:     noLabel,
          opt:       false,
          active:    value == false,
          onChanged: onChanged,
        ),
      ]);
}

// ── Individual Yes/No option with hover + press animation ──────────────────

class _YesNoOption extends StatefulWidget {
  final String label;
  final bool opt;
  final bool active;
  final ValueChanged<bool> onChanged;

  const _YesNoOption({
    required this.label,
    required this.opt,
    required this.active,
    required this.onChanged,
  });

  @override
  State<_YesNoOption> createState() => _YesNoOptionState();
}

class _YesNoOptionState extends State<_YesNoOption> {
  bool _hovered = false;
  bool _pressed = false;

  Color get _activeColor => widget.opt ? C.green : C.red;
  Color get _activeBg    => widget.opt
      ? const Color(0xFF003322)
      : const Color(0xFF1A0000);

  @override
  Widget build(BuildContext context) {
    final active = widget.active;

    final bgColor = active
        ? _activeBg
        : _hovered
            ? _activeBg.withValues(alpha: 0.35)
            : Colors.transparent;

    final borderColor = active
        ? _activeColor
        : _hovered
            ? _activeColor.withValues(alpha: 0.5)
            : C.border;

    final textColor = active
        ? _activeColor
        : _hovered
            ? _activeColor.withValues(alpha: 0.8)
            : C.textMut;

    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTap:       () => widget.onChanged(widget.opt),
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        child: AnimatedScale(
          scale:    _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve:    Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve:    Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color:        bgColor,
              borderRadius: BorderRadius.circular(999),
              border:       Border.all(color: borderColor),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color:      _activeColor.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset:     const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color:      textColor,
                fontSize:   13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
