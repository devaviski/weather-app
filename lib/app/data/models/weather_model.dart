enum Condition {
  windy,
  storm,
  thunderstorm,
  rainyDay,
  partialCloudy,
  heavyWind
}

class WeatherModel {
  //Main
  final int date;
  final double tempMin;
  final double tempMax;
  final double temp;
  final double pressure;
  final double humidity;

  //weather
  final String mainCondition;
  final String condition;
  final String icon;

  //wind
  final double windSpeed;
  final double windAngle;

  //precipitation
  final double rain;

  //location
  final String city;
  final String? country;
  final Map<String, dynamic> coordinate;

  const WeatherModel({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.temp,
    required this.pressure,
    required this.humidity,
    required this.mainCondition,
    required this.condition,
    required this.icon,
    required this.windSpeed,
    required this.windAngle,
    required this.city,
    this.country,
    required this.coordinate,
    required this.rain,
  });
}
