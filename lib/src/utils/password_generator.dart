import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PasswordGenerator {
  static String generate({
    required double length,
    required bool useUppercase,
    required bool useLowercase,
    required bool useNumbers,
    required bool useSpecialChars,
  }) {
    if (!useUppercase && !useLowercase && !useNumbers && !useSpecialChars) {
      return '';
    }

    String chars = '';
    if (useUppercase) chars += AppConstants.uppercase;
    if (useLowercase) chars += AppConstants.lowercase;
    if (useNumbers) chars += AppConstants.numbers;
    if (useSpecialChars) chars += AppConstants.special;

    final Random random = Random.secure();
    final int passwordLength = length.round();
    
    return List.generate(
      passwordLength,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  static String getStrength(double length) {
    if (length < 8) return AppConstants.weak;
    if (length < 12) return AppConstants.medium;
    return AppConstants.strong;
  }

  static Color getStrengthColor(String strength) {
    switch (strength) {
      case AppConstants.weak:
        return Colors.red;
      case AppConstants.medium:
        return Colors.orange;
      case AppConstants.strong:
        return const Color(0xFF6C63FF);
      default:
        return Colors.grey;
    }
  }
}
