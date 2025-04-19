import 'package:get_it/get_it.dart';
import 'package:mapgoogle/features/google_map/data_layer/data_source/lat_long_data_source.dart';
import 'package:mapgoogle/features/google_map/data_layer/repository/lat_long_repo_impl.dart';
import 'package:mapgoogle/features/google_map/domain_layer/repositories/lat_long_respositores.dart';
import 'package:mapgoogle/features/google_map/domain_layer/user_cases/lat_long_use_case.dart';
import 'package:mapgoogle/features/google_map/presentation/bloc/location_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
// bloc
  sl.registerFactory(() => LocationBloc(latLongUseCase: sl()));
// use case
  sl.registerLazySingleton(() => LatLongUseCase(latLongRespositores: sl()));
//
  sl.registerLazySingleton<LatLongRespositores>(() => LatLongRepoImpl(latLongDataSource: sl()));
// data source
  sl.registerLazySingleton<LatLongDataSource>(() => LatLongDataSourceImpl());
}
