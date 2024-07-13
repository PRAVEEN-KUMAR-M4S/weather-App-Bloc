import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weather/weather.dart';
import 'package:weather_bloc_app/data/screat_key.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    // on<WeatherFetchEvent>((event, emit) async {
    //   emit(WeatherLoading());
    //   try {
    //     WeatherFactory wf =
    //         WeatherFactory(openWeatherApi, language: Language.ENGLISH);
    //     final weather = await wf.currentWeatherByLocation(
  //         event.position.latitude, event.position.longitude);
    //     print(weather);
    //     emit(WeatherSuccess(weather));
    //   } catch (e) {
    //     emit(WeatherFailure());
    //   }
    // });
    on<WeatherFetchByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        WeatherFactory wf =
            WeatherFactory(openWeatherApi, language: Language.ENGLISH);
        final weather = await wf.currentWeatherByLocation(
            double.parse(event.prediction.lat!),
            double.parse(event.prediction.lng!));
        final fiveDayWeather = await wf.fiveDayForecastByLocation(
            double.parse(event.prediction.lat!),
            double.parse(event.prediction.lng!));
      
        emit(WeatherSuccess(weather,fiveDayWeather));
      } catch (e) {
        emit(WeatherFailure());
      }
    });

  }
}
