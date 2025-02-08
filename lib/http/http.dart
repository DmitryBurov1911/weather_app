import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../model/weather_model.dart';

class Http {
  Dio dio = Dio();

  static const MAIN_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  Http(this.apiKey);

  Future<Weather> getWeather(String city) async {
    final response = await dio
        .get("$MAIN_URL?q=$city&appid=$apiKey&units=metric");

    if (response.statusCode == 200) {
      return Weather.fromJson(response.data);
    } else {
      throw Exception("Sorry, but this not worked :/");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 30),
      ),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? "Unknown City";
    } else {
      throw Exception("Не удалось определить город");
    }
  }
}
