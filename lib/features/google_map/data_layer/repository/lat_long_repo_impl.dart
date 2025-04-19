import 'package:dartz/dartz.dart';
import 'package:mapgoogle/core/failure_class.dart';
import 'package:mapgoogle/features/google_map/data_layer/data_source/lat_long_data_source.dart';
import 'package:mapgoogle/features/google_map/domain_layer/entities/lat_long_entity.dart';
import 'package:mapgoogle/features/google_map/domain_layer/repositories/lat_long_respositores.dart';

class LatLongRepoImpl implements LatLongRespositores {
  final LatLongDataSource latLongDataSource;
  LatLongRepoImpl({required this.latLongDataSource});

  @override
  Future<Either<Failure, bool>> checkPermissionsOnly() async{
    return await latLongDataSource.checkPermissionsOnly();
  }

  @override
  Future<Either<Failure, LatLongEntity>> fetchLocationOnly() async {
    final result = await latLongDataSource.fetchLocationOnly();
    return result.fold(
      (failure) => left(failure),
      (latLongModel) => right(
        LatLongEntity(
          latitude: latLongModel.latitude,
          longitude: latLongModel.longitude,
        ),
      ),
    );
  }
}
