import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/components/temp_text.dart';
import 'package:weather_app/app/util.dart';
import 'package:weather_app/app/values/app_colors.dart';

class TempVerticalCard extends StatelessWidget {
  const TempVerticalCard({
    super.key,
    required this.time,
    required this.conditionIcon,
    required this.temperature,
    required this.onTap,
    required this.uniqIndex,
    required this.isActive,
  });
  final int time;
  final String conditionIcon;
  final double temperature;
  final void Function(int index) onTap;
  final int uniqIndex;
  final bool isActive;

  _updateIndex() {
    onTap(uniqIndex);
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: _updateIndex,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isActive ? AppColors.accent : AppColors.primaryDark,
          ),
          child: Column(
            children: [
              LatoText(
                  title: formatDayHrs(date: time),
                  opacity: 0.7,
                  textSize: 14.0),
              Opacity(
                opacity: 0.75,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: 'https://openweathermap.org/img/wn/$conditionIcon.png',
                ),
              ),
              TempText(value: temperature.toStringAsFixed(0)),
            ],
          ),
        ),
      ),
    );
  }
}
