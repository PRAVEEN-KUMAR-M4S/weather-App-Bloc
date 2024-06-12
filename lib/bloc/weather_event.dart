part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

final class WeatherFetchEvent extends WeatherEvent{
 final  Position position;

  const WeatherFetchEvent(this.position);
  
  @override
  List<Object> get props => [position];
}
