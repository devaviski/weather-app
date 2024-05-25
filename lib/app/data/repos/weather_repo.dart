import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/app/api_keys.dart';

import 'dart:convert' as convert;

class WeatherRepo {
  // final httpClient = http.Client();
  Future<Map<String, dynamic>?> fetchWeather({city}) async {
    try {
      final weatherData = {};
      final coord = await getCoordinate(city: city);
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast/?units=metric&lat=${coord!['lat']}&lon=${coord['long']}&appid=$WEATHER_API_KEY'));
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

  Future<Map<String, double>?> getCoordinate({city}) async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$WEATHER_API_KEY'));
      if (response.statusCode == 200) {
        final data = (convert.jsonDecode(response.body) as List)
            .cast<Map<String, dynamic>>();
        print('LATITUDE: ${data[0]['lat']}');
        return {'lat': data[0]['lat'], 'long': data[0]['lon']};
      } else {
        print("NO DATA FETCHED");
      }
    } catch (e) {
      print("SOME ERROR HAPPENED");
    }
    return null;
  }
}

final weatherRepo = Provider((ref) => WeatherRepo());
