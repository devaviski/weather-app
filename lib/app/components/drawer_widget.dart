import 'package:flutter/material.dart';
import 'package:weather_app/app/components/lato_text.dart';
import 'package:weather_app/app/values/app_colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dayHr = DateTime.now().hour;
    String saluteText = 'Good morning ☀️';
    if (dayHr > 12 && dayHr < 18) {
      saluteText = 'Good afternoon 🕑';
    }

    if (dayHr > 18 && dayHr < 24) {
      saluteText = 'Good evening 🌙';
    }
    return Container(
      padding: const EdgeInsets.only(
        top: 36,
        left: 8,
        right: 8,
      ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: LatoText(
                  title: saluteText,
                  textSize: 30.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              DrawerItem(
                mainTitle: 'City | Addis Ababa',
                subTitle: 'Change the default city.',
                icon: Icons.location_pin,
                onPressed: () {},
              ),
              DrawerItem(
                mainTitle: 'Theme | Dark',
                subTitle: 'Change the theme.',
                icon: Icons.style,
                onPressed: () {},
              ),
              DrawerItem(
                mainTitle: 'Units | °c',
                onPressed: () {},
                icon: Icons.thermostat,
                subTitle: 'Change to preferred units',
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: LatoText(
                opacity: 0.2,
                title: 'Dawit T. @ 2024',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.mainTitle,
    this.subTitle,
    required this.onPressed,
    required this.icon,
  });

  final String mainTitle;
  final String? subTitle;
  final Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        icon,
        color: AppColors.textWhite,
      ),
      title: LatoText(
        title: mainTitle,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: AppColors.textWhite,
      ),
      subtitle: subTitle == null
          ? null
          : LatoText(
              title: subTitle!,
              fontWeight: FontWeight.w300,
              textSize: 14.0,
              opacity: 0.6,
            ),
    );
  }
}
