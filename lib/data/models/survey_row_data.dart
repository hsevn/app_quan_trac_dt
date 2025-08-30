class SurveyRowData {
  String position = '';
  double light = 0;
  double temp = 0;
  double humidity = 0;

  SurveyRowData.empty();

  Map<String, dynamic> toMap() => {
        'position': position,
        'light': light,
        'temp': temp,
        'humidity': humidity,
      };

  factory SurveyRowData.fromMap(Map<String, dynamic> map) {
    return SurveyRowData.empty()
      ..position = map['position'] ?? ''
      ..light = map['light']?.toDouble() ?? 0.0
      ..temp = map['temp']?.toDouble() ?? 0.0
      ..humidity = map['humidity']?.toDouble() ?? 0.0;
  }
}
