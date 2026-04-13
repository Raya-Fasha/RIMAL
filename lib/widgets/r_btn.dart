import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool ghost;
  final bool disabled;
  final bool fullWidth;
  final String? tooltip;

  const RBtn({
    super.key,
    required this.label,
    required this.onTap,
    this.ghost     = false,
    this.disabled  = false,
    this.fullWidth = false,
    this.tooltip,
  });

  @override
  State<RBtn> createState() => _RBtnState();
}

class _RBtnState extends State<RBtn> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isGhost    = widget.ghost;
    final isDisabled = widget.disabled;

    final bgColor = isDisabled
        ? C.border
        : isGhost
            ? (_hovered ? C.blue.withValues(alpha: 0.10) : Colors.transparent)
            : (_hovered ? const Color(0xFF1A8FE8) : C.blue);

    final textColor = isDisabled
        ? C.textDim
        : isGhost
            ? (_hovered ? Colors.white : C.textMut)
            : Colors.white;

    final borderColor = isDisabled ? C.border : (_hovered ? C.borderHi : C.border);

    final shadows = (!isGhost && !isDisabled && _hovered)
        ? [
            BoxShadow(
              color:      C.blue.withValues(alpha: 0.40),
              blurRadius: 16,
              offset:     const Offset(0, 4),
            ),
          ]
        : <BoxShadow>[];

    final scale = _pressed ? 0.95 : (_hovered ? 1.03 : 1.0);

    final w = MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap:       isDisabled ? null : widget.onTap,
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        child: AnimatedScale(
          scale:    scale,
          duration: const Duration(milliseconds: 140),
          curve:    Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve:    Curves.easeOut,
            padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color:        bgColor,
              borderRadius: BorderRadius.circular(999),
              border: (isGhost || isDisabled)
                  ? Border.all(color: borderColor)
                  : null,
              boxShadow: shadows,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color:      textColor,
                fontSize:   13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    final wrapped = widget.tooltip != null
        ? Tooltip(
            message:     widget.tooltip!,
            preferBelow: true,
            decoration: BoxDecoration(
              color:        const Color(0xFF003060),
              borderRadius: BorderRadius.circular(8),
              border:       Border.all(color: const Color(0xFF0A4080)),
            ),
            textStyle: const TextStyle(color: Color(0xFF7AB0D4), fontSize: 11),
            child: w,
          )
        : w;

    return widget.fullWidth
        ? SizedBox(width: double.infinity, child: wrapped)
        : wrapped;
  }
}
