import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapgoogle/core/app_imges.dart';
import 'package:mapgoogle/core/custom_handler/bitmap_image_handler.dart';

class MarkerIconHandler {
  static Future<BitmapDescriptor> getMarkerIcon(String type) async {
    switch (type.toLowerCase()) {
      case 'current':
        final Uint8List current = await BitmapImageHandler.getBytesFromAssets(AppImges.userLocationImage, 40);
        return BitmapDescriptor.bytes(current);

      case 'source':
        final Uint8List source = await BitmapImageHandler.getBytesFromAssets(AppImges.sourceLocationImage, 40);
        return BitmapDescriptor.bytes(source);

      case 'destination':
        final Uint8List destination = await BitmapImageHandler.getBytesFromAssets(AppImges.destinationLocationImage, 40);
        return BitmapDescriptor.bytes(destination);

      default:
        return BitmapDescriptor.defaultMarker;
    }
  }
}
