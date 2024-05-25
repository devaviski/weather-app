import 'package:flutter/cupertino.dart';
import 'package:weather_app/app/util.dart';

class CityModel {
  const CityModel({
    this.id,
    required this.name,
    required this.lat,
    required this.lon,
  });
  final int? id;
  final String name;
  final double lat;
  final double lon;

  CityModel.fromJson({json})
      : id = json[columnId],
        name = json[columnCityName],
        lat = json[columnLat],
        lon = json[columnLon];

  Map<String, Object?> toJson() {
    // columnId: id > 0 ? id : null,
    var map = <String, Object?>{
      columnCityName: name,
      columnLat: lat,
      columnLon: lon,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CityModel copyWith({id, name, lat, lon}) => CityModel(
        id: id ?? this.id,
        name: name ?? this.name,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );
}
