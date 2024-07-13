import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_bloc_app/bloc/weather_bloc.dart';
import 'package:weather_bloc_app/common/widgets/search_box_place.dart';
import 'package:weather_bloc_app/data/screat_key.dart';
import 'package:weather_bloc_app/db/function/db_function.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController controller = TextEditingController();

 

  @override
  void initState() {
    super.initState();
  }

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
                  if (state is WeatherLoading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ));
                  }

                  if (state is WeatherSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GooglePlaceAutoCompleteTextField(
                              textEditingController: controller,
                              textStyle: const TextStyle(color: Colors.white),
                              googleAPIKey: googleApi,
                              inputDecoration: const InputDecoration(
                                  hintText: "Enter the city ",
                                  hintStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.location_on,
                                      color: Colors.white),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              debounceTime: 800, // default 600 ms,
                              countries: [
                                "in",
                                "fr"
                              ], // optional by default null is set
                              isLatLngRequired:
                                  true, // if you required coordinates from place detail
                              getPlaceDetailWithLatLng:
                                  (Prediction prediction) {
                                // this method will return latlng with place detail

                                context
                                    .read<WeatherBloc>()
                                    .add(WeatherFetchByCity(prediction));
                              }, // this callback is called when isLatLngRequired is true
                              itemClick: (Prediction prediction) {
                                controller.text = prediction.description!;
                                controller.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            prediction.description!.length));
                              },
                              // if we want to make custom list item builder
                              itemBuilder:
                                  (context, index, Prediction prediction) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                          child: Text(
                                              prediction.description ?? ""))
                                    ],
                                  ),
                                );
                              },
                              // if you want to add seperator between list items
                              seperatedBuilder: const Divider(),
                              // want to show close icon
                              isCrossBtnShown: true,
                              // optional container padding
                              containerHorizontalPadding: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              ' 5 days Forecast',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: state.weatherForecast
                                    .map(
                                      (e) => Container(
                                        padding: EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                                        height: 145,
                                        width: 85,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              DateFormat('E').format(e.date!),
                                              style: TextStyle(
                                                  color: Colors.white,fontWeight: FontWeight.bold),
                                            ),
                                                        Text(
                                              DateFormat().add_jm().format(e.date!),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            getWeatherImage(
                                                e.weatherConditionCode!),
                                            Text(
                                              '${e.tempFeelsLike!.celsius!.round()}°C',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                  color: Colors.white70),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Column(
                      children: [
                        SearchBoxPlace(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Enter your city in the Text Box',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
