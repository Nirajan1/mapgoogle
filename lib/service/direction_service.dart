import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapgoogle/model/direction_model.dart';
import 'package:mapgoogle/.env.dart';

class RemoteDirectionService {
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";
  final dio = Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await dio.get(baseUrl, queryParameters: {
        'origin': '${origin.latitude}, ${origin.longitude}',
        'destination': '${destination.latitude}, ${destination.longitude}',
        'key': googleAPIKey,
      });
      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      } else {
        return null;
      }
    } catch (exception) {
      debugPrint('errorL $exception');
      return null;
    }
  }
}
