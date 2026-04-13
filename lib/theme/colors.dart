import 'package:flutter/material.dart';

class C {
  static const bg       = Color(0xFF002747);
  static const card     = Color(0xFF003060);
  static const border   = Color(0xFF0A4080);
  static const borderHi = Color(0xFF1060A0);
  static const blue     = Color(0xFF0072CF);
  static const orange   = Color(0xFFFC6701);
  static const sand     = Color(0xFFF9CA90);
  static const textPrim = Color(0xFFE8F0FB);
  static const textMut  = Color(0xFF7AB0D4);
  static const textDim  = Color(0xFF3A6090);
  static const green    = Color(0xFF2EC87A);
  static const red      = Color(0xFFF05050);
}

Color statusBg(String s) {
  switch (s) {
    case 'Submitted':                       return const Color(0xFF0A2444);
    case 'Under Review':                    return const Color(0xFF162800);
    case 'Additional Information Required': return const Color(0xFF2A1800);
    case 'Approved for Sandbox':            return const Color(0xFF003322);
    case 'Rejected':                        return const Color(0xFF2A0A0A);
    default:                                return const Color(0xFF1A3050);
  }
}

Color statusFg(String s) {
  switch (s) {
    case 'Submitted':                       return C.sand;
    case 'Under Review':                    return const Color(0xFF8FC43A);
    case 'Additional Information Required': return C.orange;
    case 'Approved for Sandbox':            return C.green;
    case 'Rejected':                        return C.red;
    default:                                return C.textMut;
  }
}

Color riskBg(String r) => r == 'High'
    ? const Color(0xFF2A0A0A)
    : r == 'Medium'
        ? const Color(0xFF2A1800)
        : const Color(0xFF003322);

Color riskFg(String r) =>
    r == 'High' ? C.red : r == 'Medium' ? C.orange : C.green;
