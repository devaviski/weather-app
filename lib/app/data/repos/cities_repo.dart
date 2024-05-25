import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/util.dart';

class CitiesRepo {
  late Database db;

  Future<void> open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $tableCities ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnCityName TEXT NOT NULL, $columnLat REAL NOT NULL, $columnLon REAL NOT NULL)');
    });
  }

  Future<int> insert(CityModel city) async {
    return await db.insert(tableCities, city.toJson());
  }

  Future<void> deleteById({required int id}) async {
    await db.delete(tableCities, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update({required CityModel city}) async {
    return await db.update(tableCities, city.toJson(),
        whereArgs: [city.id], where: '$columnId = ?');
  }

  Future<List<Map<String, Object?>>> fetchCities() async {
    return await db.query(tableCities, orderBy: '$columnCityName DESC');
  }

  Future<CityModel?> cityById({required int id}) async {
    var data = await db.query(tableCities,
        columns: [columnId, columnCityName, columnLat, columnLon],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (data.isNotEmpty) {
      return CityModel.fromJson(json: data.first);
    }
    return null;
  }

  Future<void> close() async => db.close();
}

final citiesRepo = Provider((ref) => CitiesRepo());
