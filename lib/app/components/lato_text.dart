import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/app/values/app_colors.dart';

class LatoText extends StatelessWidget {
  const LatoText(
      {super.key, required this.title, fontWeight, textSize, opacity})
      : fontWeight = fontWeight ?? FontWeight.normal,
        textSize = textSize ?? 16.0,
        opacity = opacity ?? 1.0;
  final String title;
  final FontWeight? fontWeight;
  final double? textSize;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      title,
      style: GoogleFonts.lato().copyWith(
        color: AppColors.textWhite.withOpacity(opacity!),
        fontWeight: fontWeight,
        fontSize: textSize,
      ),
    );
  }
}
