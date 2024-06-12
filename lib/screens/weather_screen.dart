import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_bloc_app/bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepPurple),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepPurple),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 600,
                  decoration: const BoxDecoration(color: Color(0xFFFFAB40)),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📍 ${state.weather.areaName!}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                             Text(
                              getStatus(state.weather.date!),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            getWeatherImage(
                                state.weather.weatherConditionCode!),
                            Center(
                              child: Text(
                                '${state.weather.temperature?.celsius!.round()} °C',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 55,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Center(
                              child: Text(
                                state.weather.weatherMain!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Center(
                              child: Text(
                                DateFormat('EEEE dd -')
                                    .add_jm()
                                    .format(state.weather.date!),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/11.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Sunrise',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          DateFormat()
                                              .add_jm()
                                              .format(state.weather.sunrise!),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/12.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Sunset',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          DateFormat()
                                              .add_jm()
                                              .format(state.weather.sunset!),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/14.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Min Temp',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          '${state.weather.tempMin!.celsius!.round()}°C',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/13.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'max Temp',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          '${state.weather.tempMax!.celsius!.round()}°C',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget getWeatherImage(int code) {
  print(DateTime.now().hour);
  switch (code) {
    case >= 200 && < 300:
      return Image.asset(
        'assets/1.png',
      );
    case >= 300 && < 400:
      return Image.asset(
        'assets/2.png',
      );
    case >= 500 && < 600:
      return Image.asset(
        'assets/3.png',
      );
    case >= 600 && < 700:
      return Image.asset(
        'assets/4.png',
      );
    case >= 700 && < 800:
      return Image.asset(
        'assets/5.png',
      );
    case == 800:
      return Image.asset(
        'assets/6.png',
      );
    case >= 800 && < 805:
      return Image.asset(
        'assets/8.png',
      );

    default:
      return Image.asset(
        'assets/7.png',
      );
  }
}

String getStatus(DateTime time) {
  int hours = time.hour;
  switch (hours) {
    case >= 6 && < 12:
      return 'Good Morning';
    case >= 12 && < 16:
      return 'Good Afternoon';
    case >= 16 && < 19:
      return 'Good Evening';

    default:
      return 'Good Night';
  }
}
