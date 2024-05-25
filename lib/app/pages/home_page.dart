import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app/components/drawer_widget.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/components/main_temp_widget.dart';
import 'package:weather_app/app/components/non_temp_widget.dart';
import 'package:weather_app/app/components/other_city_card.dart';
import 'package:weather_app/app/components/rounded_icon.dart';
import 'package:weather_app/app/components/temp_vertical_card.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/data/providers/cities_provider.dart';
import 'package:weather_app/app/data/providers/weather_provider.dart';
import 'package:weather_app/app/components/city_picker_modal.dart';
import 'package:weather_app/app/pages/five_day_forecast_page.dart';
import 'package:weather_app/app/values/app_colors.dart';
import 'package:weather_app/app/values/app_values.dart';

class HomePage extends ConsumerStatefulWidget {
  // const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> onRefreshHandler() async {
    ref.watch(weatherProvider('Addis Ababa').notifier).refresh();
  }

  _addCities({context}) async {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => const CityPickerModal());
  }

  int index = 0;

  _updateIndex(int i) {
    setState(() {
      index = i;
    });
  }

  List<WeatherModel> otherDaysWeather(List<WeatherModel> weatherData) {
    int today = DateTime.now().day;
    return weatherData
        .where(
          (weather) =>
              today !=
              DateTime.fromMillisecondsSinceEpoch(weather.date * 1000).day,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider('Addis Ababa'));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: LatoText(
          title: weatherAsync.value == null ? '' : weatherAsync.value![0].city,
          fontWeight: FontWeight.bold,
          textSize: 20.0,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppValues.smallPadding),
          child: RoundedIcon(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            assetPath: 'assets/png/drawer.png',
          ),
        ),
        actions: [
          IconButton(
            color: AppColors.primaryDark,
            onPressed: onRefreshHandler,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
            ),
            icon: Image.asset(
              'assets/png/refresh.png',
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryPinkish,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: weatherAsync.when(
          data: (weathers) => Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MainTempWidget(
                condition: weathers[index].condition,
                temp: weathers[index].temp,
                timeStamp: weathers[index].date,
                icon: weathers[index].icon,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: NonTempWidget(
                  humidity: weathers[index].humidity.ceil(),
                  speed: (weathers[index].windSpeed * 3.6).ceil(),
                  rain: weathers[index].rain.ceil(),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LatoText(
                          title: 'Today',
                          opacity: 0.7,
                        ),
                        TextButton(
                          onPressed: () {
                            final list = weathers
                                .where((element) =>
                                    weathers.indexOf(element) % 8 == 0 &&
                                    weathers.indexOf(element) != 0)
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FiveDayForecastPage(
                                  weathers: otherDaysWeather(weathers),
                                ),
                              ),
                            );
                          },
                          child: const LatoText(
                            title: '4-Day Forecast',
                            opacity: 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(
                          8,
                          (i) => TempVerticalCard(
                            temperature: weathers[i].temp,
                            conditionIcon: weathers[i].icon,
                            time: weathers[i].date,
                            onTap: _updateIndex,
                            uniqIndex: i,
                            isActive: index == i,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LatoText(
                          title: 'Other Cities',
                          opacity: 0.7,
                        ),
                        IconButton(
                          onPressed: () {
                            _addCities(context: context);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ref.watch(citiesProvider).when(
                        data: (cities) {
                          if (cities.isEmpty) {
                            return Container(
                              width: MediaQuery.of(context).size.width / 1.15,
                              height: 100,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.primaryDark,
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    _addCities(context: context);
                                  },
                                  child: const LatoText(
                                    title: 'Add Cities',
                                  ),
                                ),
                              ),
                            );
                          }
                          return CarouselSlider(
                            items: (cities as List<CityModel>)
                                .map(
                                  (city) => Dismissible(
                                    direction: DismissDirection.vertical,
                                    onDismissed: (dir) async {
                                      await ref
                                          .watch(citiesProvider.notifier)
                                          .removeCity(id: city.id!);
                                    },
                                    key: Key(cities.indexOf(city).toString()),
                                    child: Center(
                                      child: OtherCityCard(city: city),
                                    ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              height: 100,
                              autoPlay: true,
                              viewportFraction: .85,
                              autoPlayInterval: const Duration(seconds: 30),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () =>
                            const CircularProgressIndicator.adaptive(),
                      ),
                ],
              ),
            ],
          ),
          error: (err, st) => Text(err.toString()),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
