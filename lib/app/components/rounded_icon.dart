import 'package:flutter/material.dart';
import 'package:weather_app/app/values/app_colors.dart';
import 'package:weather_app/app/values/app_values.dart';

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    super.key,
    required this.onTap,
    required this.assetPath,
  });
  final void Function() onTap;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Image.asset(
        assetPath,
      ),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppValues.mediumBRadius,
          ),
        ),
      ),
    );
  }
}
