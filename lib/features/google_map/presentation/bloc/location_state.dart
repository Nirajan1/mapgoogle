part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationErrorState extends LocationState {
  final String errorMessage;

  const LocationErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class LocationFetchSuccessState extends LocationState {
  final LatLongEntity latLongEntity;
  const LocationFetchSuccessState({
    required this.latLongEntity,
  });
  @override
  List<Object> get props => [latLongEntity];
}

class LocationFetchingState extends LocationState {
  final String message;
  const LocationFetchingState({this.message = 'Searching you on the map...'});
  @override
  List<Object> get props => [message];
}

class MarkerAddState extends LocationState {
  final Set<Marker> markers;
  const MarkerAddState({
    required this.markers,
  });
  @override
  List<Object> get props => [markers];
}
