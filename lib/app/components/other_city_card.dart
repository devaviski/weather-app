import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/components/temp_text.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/providers/weather_provider.dart';
import 'package:weather_app/app/values/app_colors.dart';

class OtherCityCard extends ConsumerWidget {
  const OtherCityCard({
    super.key,
    required this.city,
  });
  final CityModel city;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(cityWeatherProvider(city));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primaryDark,
        ),
        child: weatherAsync.when(
          data: (weather) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0.75,
                  // child: Image.network(
                  //   'https://openweathermap.org/img/wn/${weather!.icon}.png',
                  // ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        'https://openweathermap.org/img/wn/${weather!.icon}.png',
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LatoText(title: weather.city),
                      LatoText(title: weather.mainCondition)
                    ],
                  ),
                ),
                TempText(
                  value: weather.temp.toStringAsFixed(0),
                  textSize: 28.0,
                ),
              ],
            );
          },
          error: (err, st) => Text(err.toString()),
          loading: () => const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      ),
    );
  }
}
