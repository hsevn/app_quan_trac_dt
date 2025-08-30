class SurveyResult {
  final int? id;
  final String l1;
  final String l2;
  final String l3;
  final double anhSang;
  final double nhietDo;
  final double doAm;
  final double tocDoGio;
  final double bucXaNhiet;
  final double tiengOnChung;
  final double onGiaiTan;
  final double dienTruong;
  final double rung;
  final double buiToanPhan;
  final double khiO2;
  final double khiCO;
  final double khiCO2;
  final String? danhGiaOwas;
  final String? cauHoi;
  final String? traLoi;
  final String timestamp;
  final String? imagePath;
  final double? gpsLat;
  final double? gpsLng;

  SurveyResult({
    this.id,
    required this.l1,
    required this.l2,
    required this.l3,
    required this.anhSang,
    required this.nhietDo,
    required this.doAm,
    required this.tocDoGio,
    required this.bucXaNhiet,
    required this.tiengOnChung,
    required this.onGiaiTan,
    required this.dienTruong,
    required this.rung,
    required this.buiToanPhan,
    required this.khiO2,
    required this.khiCO,
    required this.khiCO2,
    this.danhGiaOwas,
    this.cauHoi,
    this.traLoi,
    required this.timestamp,
    this.imagePath,
    this.gpsLat,
    this.gpsLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'l1': l1,
      'l2': l2,
      'l3': l3,
      'anhSang': anhSang,
      'nhietDo': nhietDo,
      'doAm': doAm,
      'tocDoGio': tocDoGio,
      'bucXaNhiet': bucXaNhiet,
      'tiengOnChung': tiengOnChung,
      'onGiaiTan': onGiaiTan,
      'dienTruong': dienTruong,
      'rung': rung,
      'buiToanPhan': buiToanPhan,
      'khiO2': khiO2,
      'khiCO': khiCO,
      'khiCO2': khiCO2,
      'danhGiaOwas': danhGiaOwas,
      'cauHoi': cauHoi,
      'traLoi': traLoi,
      'timestamp': timestamp,
      'imagePath': imagePath,
      'gpsLat': gpsLat,
      'gpsLng': gpsLng,
    };
  }

  factory SurveyResult.fromMap(Map<String, dynamic> map) {
    return SurveyResult(
      id: map['id'],
      l1: map['l1'],
      l2: map['l2'],
      l3: map['l3'],
      anhSang: map['anhSang'],
      nhietDo: map['nhietDo'],
      doAm: map['doAm'],
      tocDoGio: map['tocDoGio'],
      bucXaNhiet: map['bucXaNhiet'],
      tiengOnChung: map['tiengOnChung'],
      onGiaiTan: map['onGiaiTan'],
      dienTruong: map['dienTruong'],
      rung: map['rung'],
      buiToanPhan: map['buiToanPhan'],
      khiO2: map['khiO2'],
      khiCO: map['khiCO'],
      khiCO2: map['khiCO2'],
      danhGiaOwas: map['danhGiaOwas'],
      cauHoi: map['cauHoi'],
      traLoi: map['tra]()
