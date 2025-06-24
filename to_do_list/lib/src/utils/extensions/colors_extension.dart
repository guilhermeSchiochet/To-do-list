import 'package:flutter/material.dart';

extension CColor on Color {
  Color withAlphaPercent(double percent) {
    return withValues(alpha: percent.clamp(0.0, 1.0));
  }
}