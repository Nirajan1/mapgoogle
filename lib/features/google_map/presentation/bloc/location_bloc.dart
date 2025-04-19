import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapgoogle/core/custom_handler/marker_icon_handler.dart';

import 'package:mapgoogle/core/failure_class.dart';
import 'package:mapgoogle/features/google_map/domain_layer/entities/lat_long_entity.dart';
import 'package:mapgoogle/features/google_map/domain_layer/user_cases/lat_long_use_case.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LatLongUseCase latLongUseCase;

  LocationBloc({required this.latLongUseCase}) : super(LocationInitial()) {
    on<LocationFetchEvent>(_locationFetchEvent);
    on<MarkerAddEvents>(markerAddEvents);
  }

  Future<void> _locationFetchEvent(LocationFetchEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoadingState());

    try {
      // Check permissions first
      final permissionResult = await latLongUseCase.checkPermissionsOnly();

      await permissionResult.fold(
        (failure) async {
          if (failure is LocationPermissionDeniedForeverFailure) {
            emit(LocationErrorState(errorMessage: failure.message));
          } else {
            emit(LocationErrorState(errorMessage: failure.message));
          }
        },
        (_) async {
          emit(const LocationFetchingState());

          // Fetch location after permissions are verified
          final locationResult = await latLongUseCase.fetchLocationOnly();
          locationResult.fold(
            (failure) => emit(LocationErrorState(errorMessage: failure.message)),
            (latlongEntity) {
              emit(LocationFetchSuccessState(latLongEntity: latlongEntity));
            },
          );
        },
      );
    } catch (e) {
      emit(const LocationErrorState(errorMessage: 'An unexpected error occurred'));
    }
  }

  final Set<Marker> _markers = {};

  FutureOr<void> markerAddEvents(MarkerAddEvents event, Emitter<LocationState> emit) async {
    final BitmapDescriptor icon = await MarkerIconHandler.getMarkerIcon(event.type);
    final newMarker = Marker(
      markerId: MarkerId(DateTime.now().toIso8601String()),
      position: LatLng(event.latLng.latitude, event.latLng.longitude),
      infoWindow: InfoWindow(title: event.type),
      icon: icon,
      draggable: true,
    );
    _markers.add(newMarker);
    emit(MarkerAddState(markers: _markers));
  }
}
