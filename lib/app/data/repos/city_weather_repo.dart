import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/app/api_keys.dart';

import 'dart:convert' as convert;

class CityWeatherRepo {
  // final httpClient = http.Client();
  Future<Map<String, dynamic>?> fetchWeather({lat, lon}) async {
    try {
      final weatherData = {};

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$lat&lon=$lon&appid=$WEATHER_API_KEY'));
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      // httpClient.close();
    }
    return null;
  }
}

final cityWeatherRepo = Provider((ref) => CityWeatherRepo());
