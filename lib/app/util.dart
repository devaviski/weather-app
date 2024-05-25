import 'dart:async';

import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

String getFormattedDouble({required double value}) {
  return value.toStringAsFixed(2);
}

String formattedDate({required int date}) {
  return DateFormat.MMMMEEEEd()
      .format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
}

String formatDayHrs({required int date}) {
  return DateFormat('h a')
      .format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
}

String capitalize({required String phrase}) {
  final list = phrase.split(' ');
  String capitalized = '';
  for (final l in list) {
    capitalized =
        '$capitalized ${l[0].toUpperCase()}${l.substring(1).toLowerCase()}';
  }
  return capitalized;
}

//Database columns
const String tableCities = 'city';
const String columnId = '_id';
const String columnCityName = 'name';
const String columnLat = 'lat';
const String columnLon = 'lon';

class Debouncer {
  Timer? timer;
  Debouncer();

  void run({required int duration, callback}) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    } else {
      timer = Timer(Duration(milliseconds: duration ?? 500), callback);
    }
  }

  void dispose() => timer?.cancel();
}
