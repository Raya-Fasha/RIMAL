import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';

class RInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const RInput({
    super.key,
    required this.placeholder,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller:       controller,
        maxLines:         maxLines,
        keyboardType:     keyboardType,
        inputFormatters:  inputFormatters,
        style: const TextStyle(color: C.textPrim, fontSize: 14),
        decoration: InputDecoration(
          hintText:  placeholder,
          hintStyle: const TextStyle(color: C.textDim, fontSize: 14),
          filled:    true,
          fillColor: C.bg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.blue, width: 1.5)),
        ),
      );
}
