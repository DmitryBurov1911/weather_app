import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/http/http.dart';
import 'package:weather_app/model/weather_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;
  String _assetsName = "assets/sunny.json";

  final _http = Http("84d9fafec8565e461501d6948eacda56");
  Weather? _weather;

  _fetchWeather() async {
    String city = await _http.getCurrentCity();

    try {
      final weather = await _http.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _fetchWeather();
    _checkTime();
    super.initState();
  }

  void _checkTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 18 || hour <= 6) {
      setState(() {
        _isDarkMode = true;
        _assetsName = "assets/moon.json";
      });
    } else {
      setState(() {
        _isDarkMode = false;
        _assetsName = "assets/sunny.json";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var colorText =  _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.white10 : Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 150, bottom: 150),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 50,
                    color: colorText,
                  ),
                  const SizedBox(height: 30,),
                  Text(
                    "${_weather?.city ?? "Loading city..."}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 30,
                            color: colorText,
                            fontWeight: FontWeight.w700,
                        )
                    ),
                  ),
                  SizedBox(height: size.height / 20,),
                  Lottie.asset(_assetsName),
                  SizedBox(height: size.height / 20,),
                  Text(
                    "${_weather?.temperature.round()}℃",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: colorText,
                        fontWeight: FontWeight.w300
                      )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
