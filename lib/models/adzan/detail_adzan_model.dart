class DataAdzan {
  final String id;
  final String lokasi;
  final String daerah;
  final Koordinat koordinat;
  final JadwalAdzan jadwal;
  DataAdzan({
    required this.id,
    required this.lokasi,
    required this.daerah,
    required this.koordinat,
    required this.jadwal,
  });
  factory DataAdzan.fromJson(Map<String, dynamic> json) {
    return DataAdzan(
      id: json['id'] ?? '',
      lokasi: json['lokasi'] ?? '',
      daerah: json['daerah'] ?? '',
      koordinat: Koordinat.fromJson(json['koordinat']),
      jadwal: JadwalAdzan.fromJson(json['jadwal']),
    );
  }
}

class Koordinat {
  final double lat;
  final double lon;
  final String lintang;
  final String bujur;
  Koordinat({
    required this.lat,
    required this.lon,
    required this.lintang,
    required this.bujur,
  });

  factory Koordinat.fromJson(Map<String, dynamic> json) {
    return Koordinat(
      lat: json['lat'] ?? '',
      lon: json['lon'] ?? '',
      lintang: json['lintang'] ?? '',
      bujur: json['bujur'] ?? '',
    );
  }
}

class JadwalAdzan {
  final String tanggal;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String date;
  JadwalAdzan({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.date,
  });
  factory JadwalAdzan.fromJson(Map<String, dynamic> json) {
    return JadwalAdzan(
      tanggal: json['tanggal'] ?? '',
      imsak: json['imsak'] ?? '',
      subuh: json['subuh'] ?? '',
      terbit: json['terbit'] ?? '',
      dhuha: json['dhuha'] ?? '',
      dzuhur: json['dzuhur'] ?? '',
      ashar: json['ashar'] ?? '',
      maghrib: json['maghrib'] ?? '',
      isya: json['isya'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
