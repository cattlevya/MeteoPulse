/// Model lokasi kota hasil Geocoding Open-Meteo atau penyimpanan lokal.
class Location {
  final String name;
  final String admin1;
  final String country;
  final double latitude;
  final double longitude;

  const Location({
    required this.name,
    required this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  /// Lokasi default saat penyimpanan lokal masih kosong.
  static const Location jakarta = Location(
    name: 'Jakarta',
    admin1: 'DKI Jakarta',
    country: 'Indonesia',
    latitude: -6.17806,
    longitude: 106.63,
  );

  /// Membuat Location dari JSON Geocoding atau storage.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: (json['name'] as String?) ?? '',
      admin1: (json['admin1'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Mengubah Location ke JSON untuk penyimpanan lokal.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'admin1': admin1,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Keterangan wilayah, misalnya "DKI Jakarta, Indonesia".
  String get subtitle {
    final parts = <String>[];
    if (admin1.isNotEmpty) parts.add(admin1);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
