import 'package:dartz/dartz.dart';
import 'package:location/location.dart';
import 'package:mapgoogle/core/failure_class.dart';
import 'package:mapgoogle/features/google_map/data_layer/model/lat_long_model.dart';

abstract class LatLongDataSource {
  Future<Either<Failure, bool>> checkPermissionsOnly();
  Future<Either<Failure, LatLongModel>> fetchLocationOnly();
}

class LatLongDataSourceImpl implements LatLongDataSource {
  final Location _location = Location();

  @override
  Future<Either<Failure, bool>> checkPermissionsOnly() async {
    try {
      final isServiceEnabled = await _checkLocationServiceEnabled();

      if (!isServiceEnabled) {
        return left(LocationServiceFailure('Location Service is disabled'));
      }

      PermissionStatus permissionGranted = await _checkPermission();

      if (permissionGranted == PermissionStatus.deniedForever) {
        return left(LocationPermissionDeniedForeverFailure('Location Permission are denied forever'));
      }

      if (permissionGranted == PermissionStatus.denied) {
        return left(LocationPermissionFailure('Location Permission are denied'));
      }

      return right(true);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LatLongModel>> fetchLocationOnly() async {
    try {
      final LocationData locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return left(UnknownFailure('Could not retrieve location coordinates.'));
      }
      final latLong = LatLongModel(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
      return right(latLong);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<bool> _checkLocationServiceEnabled() async {
    bool isServiceEnabled = await _location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await _location.requestService();
    }
    return isServiceEnabled;
  }

  Future<PermissionStatus> _checkPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted;
  }
}
