import 'package:flutter/widgets.dart';

/// Palette tokens: warm off-whites and near-black ink.
abstract final class AppColors {
  /// Scaffold background.
  static const canvas = Color(0xFFF6F4EF);

  /// Cards, inputs and sheets.
  static const surface = Color(0xFFFFFFFF);

  /// Image wells and loading placeholders.
  static const surfaceMuted = Color(0xFFEEEBE4);

  /// Primary text, filled buttons and selected controls.
  static const ink = Color(0xFF141414);

  /// Secondary text. At least 4.5:1 on [canvas] and [surface].
  static const inkMuted = Color(0xFF6B675F);

  /// 1 px borders and dividers.
  static const hairline = Color(0xFFDDD8CE);

  static const error = Color(0xFF8E3B2F);
}
