import 'package:flutter/material.dart';

/// Andura's brand and semantic color palette.
abstract final class AnduraColors {
  static const primary = Color(0xFF6B72FF);
  static const primaryDeep = Color(0xFF5C62FD);
  static const yellow = Color(0xFFFECC30);
  static const mint = Color(0xFF6BD4AE);
  static const red = Color(0xFFFF374B);
  static const donutYellow = Color(0xFFFDF031);

  static const scaffold = Colors.white;
  static const searchFill = Color(0xFFF8F8F8);
  static const emphasizedSurface = Color(0xFFD4D6F3);
  static const subtleSurface = Color(0xFFF6F4FC);

  static const pastelMint = Color(0xFFF1F7EE);
  static const pastelLavender = Color(0xFFF1EDFA);
  static const pastelBlue = Color(0xFFDFEEF4);
  static const pastels = [pastelMint, pastelLavender, pastelBlue];

  static const textDark = Color(0xFF16161E);
  static const textGray = Color(0xFF7B7B8B);

  static const success = mint;
  static const warning = yellow;
  static const danger = red;
}
