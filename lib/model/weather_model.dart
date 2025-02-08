class Weather {
  final dynamic city;
  final dynamic temperature;
  final dynamic condition;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        city: json["name"],
        temperature: json["main"]["temp"],
        condition: json["weather"][0],
    );
  }
}
