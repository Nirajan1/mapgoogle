import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  LatLngBounds? bounds;

  List<PointLatLng>? polylinePoints;
  String? totalDistance;
  String? totalDuration;

  Directions({
    this.bounds,
    this.polylinePoints,
    this.totalDistance,
    this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return Directions();

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);
    // Bounds
    final northeast = data['bounds']['northeast'];
    final southeast = data['bounds']['southeast'];
    final bounds = LatLngBounds(
      southwest: LatLng(southeast['lat'], southeast['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints: data['overview_polyline']['points'],
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
