class SurveyRowData {
  int? id;
  String position;
  double light;
  double temp;
  double humidity;

  SurveyRowData({
    this.id,
    this.position = '',
    this.light = 0,
    this.temp = 0,
    this.humidity = 0,
  });

  SurveyRowData.empty() : this();

  Map<String, dynamic> toMap() => {
        'id': id,
        'position': position,
        'light': light,
        'temp': temp,
        'humidity': humidity,
      };

  factory SurveyRowData.fromMap(Map<String, dynamic> map) {
    return SurveyRowData(
      id: map['id'],
      position: map['position'] ?? '',
      light: (map['light'] as num?)?.toDouble() ?? 0,
      temp: (map['temp'] as num?)?.toDouble() ?? 0,
      humidity: (map['humidity'] as num?)?.toDouble() ?? 0,
    );
  }
}
