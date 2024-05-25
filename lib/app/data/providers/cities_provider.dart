import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/repos/cities_repo.dart';
import 'package:weather_app/app/data/repos/weather_repo.dart';
import 'package:weather_app/app/util.dart';

class CitiesAsyncNotifier extends AsyncNotifier {
  final List<CityModel> _list = [];
  late CitiesRepo _citiesRepo;
  late String path;
  @override
  FutureOr<List<CityModel>> build() async {
    final dbPath = await getDatabasesPath();
    path = join(dbPath, 'cities.db');
    _citiesRepo = ref.read(citiesRepo);
    await _citiesRepo.open(path);
    return await _fetchCities();
  }

  Future<List<CityModel>> _fetchCities() async {
    final data = await _citiesRepo.fetchCities();
    final List<CityModel> cities = [];
    for (final json in data) {
      cities.add(CityModel.fromJson(json: json));
    }
    return cities;
  }

  Future<void> addCity(BuildContext context, {required String city}) async {
    final coord = await ref.read(weatherRepo).getCoordinate(city: city);
    if (coord == null) return;
    final cityModel = CityModel(
      name: city,
      lat: coord['lat']!,
      lon: coord['long']!,
    );
    final oldList = <CityModel>[...state.value!];
    final cityExists =
        oldList.where((cityM) => cityM.name == city).toList().isNotEmpty;
    if (!cityExists) {
      final id = await _citiesRepo.insert(cityModel);
      final list = <CityModel>[cityModel.copyWith(id: id), ...oldList];
      state = await AsyncValue.guard(() async => list);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('City already added'),
        ),
      );
    }
  }

  Future<void> removeCity({required int id}) async {
    final oldCities = <CityModel>[...state.value!];
    state = await AsyncValue.guard(
        () async => oldCities.where((element) => element.id != id).toList());
    await _citiesRepo.deleteById(id: id);
    // ref.invalidateSelf();
  }
}

final citiesProvider = AsyncNotifierProvider(() => CitiesAsyncNotifier());
