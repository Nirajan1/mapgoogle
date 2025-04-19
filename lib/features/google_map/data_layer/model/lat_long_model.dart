import 'package:mapgoogle/features/google_map/domain_layer/entities/lat_long_entity.dart';

class LatLongModel extends LatLongEntity {
  const LatLongModel({required super.latitude, required super.longitude});
  factory LatLongModel.fromJson(Map<String, dynamic> json) {
    return LatLongModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
