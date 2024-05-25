import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:weather_app/app/data/providers/cities_provider.dart';
import 'package:weather_app/app/util.dart';
import 'package:weather_app/app/values/app_colors.dart';
import 'package:country_state_city/country_state_city.dart';

class CityPickerModal extends ConsumerStatefulWidget {
  const CityPickerModal({super.key});

  @override
  ConsumerState<CityPickerModal> createState() => _CityPickerModalState();
}

class _CityPickerModalState extends ConsumerState<CityPickerModal> {
  List<String> cities = [];
  final deBouncer = Debouncer();
  List<String> queryCities = [];

  @override
  void initState() {
    getTheCities();
    super.initState();
  }

  @override
  void dispose() {
    deBouncer.dispose();
    super.dispose();
  }

  getTheCities() async {
    final List<City> allCities = await getAllCities();
    cities = allCities.map((city) => city.name).toList();
  }

  _onChangedHandler({String? value}) async {
    final name = value?.trim() ?? '';
    setState(() {
      if (name.isEmpty) {
        queryCities = [];
      } else {
        queryCities = cities
            .where((cityName) =>
                cityName.toLowerCase().contains(name.toLowerCase()))
            .toList();
      }
    });
  }

  _onCitySelectedHandler(city, BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    ref.read(citiesProvider.notifier).addCity(context, city: city);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewPadding.bottom),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              deBouncer.run(
                duration: 300,
                callback: () {
                  _onChangedHandler(value: value);
                },
              );
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primaryPinkish,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primaryPinkish.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          if (queryCities.isEmpty) const Text('No items to show'),
          if (queryCities.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: queryCities.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    queryCities[index],
                  ),
                  onTap: () {
                    _onCitySelectedHandler(
                      queryCities[index],
                      context,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
