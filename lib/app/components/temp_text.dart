import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/app/values/app_colors.dart';

class TempText extends StatelessWidget {
  final String value;
  final double? textSize;
  final FontWeight? fontWeight;
  final bool? hasShadow;
  const TempText({
    super.key,
    required this.value,
    textSize,
    fontWeight,
    this.hasShadow,
  })  : textSize = textSize ?? 16.0,
        fontWeight = fontWeight ?? FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$value°',
      style: GoogleFonts.lato().copyWith(
          color: AppColors.textWhite,
          fontSize: textSize,
          fontWeight: fontWeight,
          shadows: hasShadow ?? false
              ? [const Shadow(color: AppColors.primary, offset: Offset(1, 1))]
              : null),
    );
  }
}
