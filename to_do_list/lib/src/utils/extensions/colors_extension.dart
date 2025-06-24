import 'dart:math' as math;
import 'package:flutter/material.dart';

extension CColor on Color {
  Color withAlphaPercent(double percent) {
    return withOpacity(percent.clamp(0.0, 1.0));
  }
}