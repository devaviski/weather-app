import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/components/temp_text.dart';
import 'package:weather_app/app/util.dart';

class MainTempWidget extends StatelessWidget {
  const MainTempWidget({
    super.key,
    required this.condition,
    required this.temp,
    required this.timeStamp,
    required this.icon,
  });
  final String condition;
  final double temp;
  final int timeStamp;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LatoText(title: capitalize(phrase: condition)),
        SizedBox(
          height: 160,
          width: MediaQuery.of(context).size.width / 2,
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -40,
                child: Opacity(
                  opacity: 0.75,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'https://openweathermap.org/img/wn/$icon@4x.png',
                  ),
                ),
              ),
              Positioned(
                top: -10,
                left: 0,
                child: TempText(
                  hasShadow: true,
                  value: temp.toStringAsFixed(0),
                  textSize: 100.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        LatoText(
          title:
              '${formattedDate(date: timeStamp)} | ${formatDayHrs(date: timeStamp)}',
        ),
      ],
    );
  }
}
