import 'package:equatable/equatable.dart';

class LatLongEntity extends Equatable {
  final double latitude;
  final double longitude;
  const LatLongEntity({
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object?> get props => [latitude, longitude];
}
