part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationFetchEvent extends LocationEvent {
  const LocationFetchEvent();
  @override
  List<Object> get props => [];
}

class MarkerAddEvents extends LocationEvent {
  final LatLng latLng;
  final String type;
  const MarkerAddEvents({
    required this.latLng,
    required this.type,
  });
  @override
  List<Object> get props => [latLng, type];
}
