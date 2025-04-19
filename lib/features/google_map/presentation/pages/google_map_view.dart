import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapgoogle/features/google_map/presentation/bloc/location_bloc.dart';
import 'package:app_settings/app_settings.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 14.4746,
  );

  Future<void> _goToUserLocation(CameraPosition cameraPosition, LatLng position) async {
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationErrorState) {
              dialogBoxWidget(context, state);
            }
            if (state is LocationFetchSuccessState) {
              print('is cussrer ${state is LocationFetchSuccessState}');

              LatLng position = LatLng(state.latLongEntity.latitude, state.latLongEntity.longitude);
              CameraPosition newPosition = CameraPosition(
                bearing: 192.8334901395799,
                target: position,
                tilt: 59.440717697143555,
                zoom: 19.151926040649414,
              );
              _goToUserLocation(newPosition, position);
              // context.read<LocationBloc>().add(MarkerAddEvents(latLng: position, type: 'Current'));
            }
          },
          builder: (context, state) {
            print('is cussrer ${state is LocationFetchSuccessState}');

            return Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,

                  // myLocationButtonEnabled: state is LocationFetchSuccessState,
                  // myLocationEnabled: state is LocationFetchSuccessState,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: state is MarkerAddState ? state.markers : {},
                ),
                if (state is LocationFetchingState)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state is LocationFetchSuccessState)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Card(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Text('sdad'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> dialogBoxWidget(BuildContext context, LocationErrorState state) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search),
            Text('We require your precise location to seamlessly connect you to nearby service providers. \n Please turn on device location.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (state.errorMessage == 'Location Service is disabled') context.read<LocationBloc>().add(const LocationFetchEvent());
              if (state.errorMessage == 'Location Permission are denied forever') AppSettings.openAppSettings();
            },
            child: const Text(
              'Try again',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
