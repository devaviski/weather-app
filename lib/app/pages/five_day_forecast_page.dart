import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/components/non_temp_widget.dart';
import 'package:weather_app/app/components/temp_text.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/util.dart';
import 'package:weather_app/app/values/app_colors.dart';

class FiveDayForecastPage extends StatelessWidget {
  const FiveDayForecastPage({
    super.key,
    required this.weathers,
  });
  final List<WeatherModel> weathers;

  @override
  Widget build(BuildContext context) {
    final tomorrowsWeather = List.generate(
      8,
      (index) => weathers[index],
    );
    final minTemp = min(
      tomorrowsWeather.map((weather) => weather.tempMin).toList(),
    );
    final maxTemp = max(
      tomorrowsWeather.map((weather) => weather.tempMax).toList(),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
            color: AppColors.textWhite,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const LatoText(
          title: '4 Days',
          fontWeight: FontWeight.w900,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryPinkish],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 216,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const LatoText(
                                    title: 'Tomorrow',
                                    textSize: 14.0,
                                  ),
                                  LatoText(
                                    title: capitalize(
                                      phrase: weathers[0].condition,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -50,
                            left: -20,
                            child: Opacity(
                              opacity: 0.6,
                              child: Image.network(
                                'https://openweathermap.org/img/wn/${weathers[0].icon}@4x.png',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 24,
                            child: RichText(
                              text: TextSpan(
                                text:
                                    '${maxTemp > 0 ? '' : '-'}${maxTemp.toStringAsFixed(0)}°',
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '/${minTemp < 0 ? '-' : ''}${minTemp.toStringAsFixed(0)}°',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              child: PrecipitationRow(
                                humidity: weathers[0].humidity.ceil(),
                                rain: weathers[0].rain.ceil(),
                                speed: weathers[0].windSpeed.ceil(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        final nthList = nthDaysList(index);
                        final minTemp = min(
                            nthList.map((weather) => weather.tempMin).toList());
                        final maxTemp = max(
                            nthList.map((weather) => weather.tempMax).toList());
                        if (index != 0) {
                          return ItemCard(
                            weather: nthList[0],
                            max: maxTemp,
                            min: minTemp,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    // for (int i = 1; i < weathers.length; i++)
                    //   ItemCard(
                    //     weather: weathers[i],
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<WeatherModel> nthDaysList(n) {
    final List<WeatherModel> nthList = [];
    for (int i = n * 8; i < (n + 1) * 8; i++) {
      nthList.add(weathers[i]);
    }
    return nthList;
  }

  double min(List<double> temps) {
    double minTemp = double.infinity;
    for (final temp in temps) {
      if (temp < minTemp) {
        minTemp = temp;
      }
    }
    return minTemp;
  }

  double max(List<double> temps) {
    double maxTemp = -double.infinity;
    for (final temp in temps) {
      if (temp > maxTemp) {
        maxTemp = temp;
      }
    }
    return maxTemp;
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.weather,
    required this.max,
    required this.min,
  });
  final WeatherModel weather;
  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryDark,
      shadowColor: AppColors.primaryPinkish,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.only(right: 24.0),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: LatoText(
                title: DateFormat.EEEE().format(
                  DateTime.fromMillisecondsSinceEpoch(weather.date * 1000),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        'https://openweathermap.org/img/wn/${weather.icon}.png',
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LatoText(
                        title: capitalize(
                          phrase: weather.condition,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TempText(
                            value:
                                '${max > 0 ? '+' : '-'}${max.ceil().toStringAsFixed(0)}',
                          ),
                          const Text(' | '),
                          TempText(
                            value:
                                '${min > 0 ? '+' : '-'}${min.floor().toStringAsFixed(0)}',
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
