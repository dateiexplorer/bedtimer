import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.wheelBackgroundColor,
    required this.secondaryBackgroundColor,
  });

  final Color? wheelBackgroundColor;
  final Color? secondaryBackgroundColor;

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? wheelBackgroundColor,
    Color? secondaryBackgroundColor,
  }) {
    return CustomColors(
      wheelBackgroundColor: wheelBackgroundColor ?? this.wheelBackgroundColor,
      secondaryBackgroundColor:
          secondaryBackgroundColor ?? this.secondaryBackgroundColor,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }

    return CustomColors(
      wheelBackgroundColor:
          Color.lerp(wheelBackgroundColor, other.wheelBackgroundColor, t),
      secondaryBackgroundColor: Color.lerp(
          secondaryBackgroundColor, other.secondaryBackgroundColor, t),
    );
  }
}
