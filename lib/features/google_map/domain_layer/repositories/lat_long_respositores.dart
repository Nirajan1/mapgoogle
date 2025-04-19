import 'package:dartz/dartz.dart';
import 'package:mapgoogle/core/failure_class.dart';
import 'package:mapgoogle/features/google_map/domain_layer/entities/lat_long_entity.dart';

abstract class LatLongRespositores {
  Future<Either<Failure, LatLongEntity>> fetchLocationOnly();
  Future<Either<Failure, bool>> checkPermissionsOnly();
}
