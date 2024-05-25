import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/data/repos/city_weather_repo.dart';
import 'package:weather_app/app/data/repos/weather_repo.dart';

class WeatherAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<WeatherModel>, String> {
  List<WeatherModel> _list = [];
  @override
  FutureOr<List<WeatherModel>> build(String arg) async {
    await _fetchWeatherData(city: arg);
    return _list;
  }

  _fetchWeatherData({city}) async {
    final weatherData = await ref.watch(weatherRepo).fetchWeather(city: city);
    if (weatherData == null) return;

    for (final data
        in (weatherData['list'] as List).cast<Map<String, dynamic>>()) {
      _list.add(
        WeatherModel(
          date: data['dt'],
          tempMin: data['main']['temp_min'].toDouble(),
          tempMax: data['main']['temp_max'].toDouble(),
          temp: data['main']['temp'].toDouble(),
          pressure: data['main']['pressure'].toDouble(),
          humidity: data['main']['humidity'].toDouble(),
          mainCondition: data['weather'][0]['main'],
          condition: data['weather'][0]['description'],
          icon: data['weather'][0]['icon'],
          windSpeed: data['wind']['speed'].toDouble(),
          windAngle: data['wind']['deg'].toDouble(),
          city: weatherData['city']['name'],
          country: weatherData['country'],
          coordinate: (weatherData['city']['coord']) as Map<String, dynamic>,
          rain: data['clouds']['all'].toDouble(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _list = [];
    await _fetchWeatherData(city: arg);
    state = await AsyncValue.guard(() async {
      return _list;
    });
  }
}

final weatherProvider = AutoDisposeAsyncNotifierProviderFamily<
    WeatherAsyncNotifier, List<WeatherModel>, String>(
  () => WeatherAsyncNotifier(),
);

final cityWeatherProvider =
    AutoDisposeFutureProviderFamily((ref, CityModel city) async {
  final weatherRepo = ref.read(cityWeatherRepo);
  final weatherData =
      await weatherRepo.fetchWeather(lat: city.lat, lon: city.lon);
  if (weatherData == null) return null;
  return WeatherModel(
    date: weatherData['dt'],
    tempMin: weatherData['main']['temp_min'].toDouble(),
    tempMax: weatherData['main']['temp_max'].toDouble(),
    temp: weatherData['main']['temp'].toDouble(),
    pressure: weatherData['main']['pressure'].toDouble(),
    humidity: weatherData['main']['humidity'].toDouble(),
    mainCondition: weatherData['weather'][0]['main'],
    condition: weatherData['weather'][0]['description'],
    icon: weatherData['weather'][0]['icon'],
    windSpeed: weatherData['wind']['speed'].toDouble(),
    windAngle: weatherData['wind']['deg'].toDouble(),
    city: city.name,
    country: weatherData['country'],
    coordinate: {'lat': city.lat, 'lon': city.lon},
    rain: weatherData['clouds']['all'].toDouble(),
  );
});
