import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/values/app_colors.dart';

class NonTempWidget extends StatelessWidget {
  const NonTempWidget({
    super.key,
    required this.rain,
    required this.humidity,
    required this.speed,
  });
  final int rain;
  final int humidity;
  final int speed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PrecipitationRow(rain: rain, humidity: humidity, speed: speed),
    );
  }
}

class PrecipitationRow extends StatelessWidget {
  const PrecipitationRow({
    super.key,
    required this.rain,
    required this.humidity,
    required this.speed,
  });

  final int rain;
  final int humidity;
  final int speed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CardItem(
          assetPath: 'assets/png/umbrella.png',
          value: '$rain%',
          title: 'Precipitation',
        ),
        CardItem(
          assetPath: 'assets/png/water_drop.png',
          value: '$humidity%',
          title: 'Humidity',
        ),
        CardItem(
          assetPath: 'assets/png/wind.png',
          value: '${speed}km/h',
          title: 'Wind',
        )
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.assetPath,
    required this.value,
    required this.title,
  });
  final String assetPath;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            assetPath,
            width: 24,
          ),
          const SizedBox(
            height: 4,
          ),
          LatoText(
            title: value,
            fontWeight: FontWeight.w900,
          ),
          const SizedBox(
            height: 4,
          ),
          LatoText(
            title: title,
            textSize: 14.0,
            fontWeight: FontWeight.w200,
            opacity: 0.7,
          ),
        ],
      ),
    );
  }
}
