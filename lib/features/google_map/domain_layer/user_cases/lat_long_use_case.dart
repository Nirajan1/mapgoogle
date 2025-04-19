import 'package:dartz/dartz.dart';
import 'package:mapgoogle/core/failure_class.dart';
import 'package:mapgoogle/features/google_map/domain_layer/entities/lat_long_entity.dart';
import 'package:mapgoogle/features/google_map/domain_layer/repositories/lat_long_respositores.dart';

class LatLongUseCase {
  final LatLongRespositores latLongRespositores;
  LatLongUseCase({required this.latLongRespositores});
  Future<Either<Failure, LatLongEntity>> fetchLocationOnly() {
    return latLongRespositores.fetchLocationOnly();
  }

  Future<Either<Failure, bool>> checkPermissionsOnly() {
    return latLongRespositores.checkPermissionsOnly();
  }
}
