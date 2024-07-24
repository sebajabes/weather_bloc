import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/misc/const.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>(fetchWeather);
  }

  FutureOr<void> fetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      WeatherFactory weatherFactory = WeatherFactory(
        AppConfig().weatherApiKey!,
        language: Language.INDONESIAN,
      );

      Weather weather = await weatherFactory.currentWeatherByLocation(
        event.position.latitude,
        event.position.longitude,
      );

      print(weather);
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(WeatherFailure());
    }
  }
}
