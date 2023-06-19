import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //* Create camera inital positon
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(26.794386, 87.281727),
    zoom: 11.5,
  );

  //* Create googlemap controller variable
  GoogleMapController? _googleMapController;

  //* Create Marker for marking
  Marker? _origin;
  Marker? _destination;

  //* Create a marker function to add and remove markers
  void _addMarker(LatLng position) {
    if (_origin == null || (_origin != null && _destination != null)) {
      // * origin in not set OR both origin and destination is set
      // * set origin
      setState(() {
        _origin = Marker(
          draggable: true,
          infoWindow: const InfoWindow(title: 'Origin'),
          markerId: const MarkerId('origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          position: position,
        );
        // * reset destination
        _destination = null;
      });
    } else {
      // * origin is already set
      // *  set destination
      setState(
        () {
          _destination = Marker(
            draggable: true,
            infoWindow: const InfoWindow(title: 'Destination'),
            markerId: const MarkerId('destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            position: position,
          );
        },
      );
    }
  }

  //*Dispose the controller
  @override
  void dispose() {
    super.dispose();
    _googleMapController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Google map'),
          actions: [
            if (_origin != null)
              TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _origin!.position,
                      tilt: 16.5,
                      zoom: 15.2,
                    ),
                  ),
                ),
                child: const Text(
                  'Origin',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            if (_destination != null)
              TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _destination!.position,
                      tilt: 16.5,
                      zoom: 15.2,
                    ),
                  ),
                ),
                child: const Text(
                  'Destination',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),

        //  ? Create floating action to center the map
        floatingActionButton: FloatingActionButton(
          elevation: .2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          onPressed: () => _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              _initialCameraPosition,
            ),
          ),
          child: const Icon(Icons.center_focus_strong),
        ),

        body: GoogleMap(
          compassEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) => _googleMapController = controller,
          markers: {
            if (_origin != null) _origin!,
            if (_destination != null) _destination!,
          },
          onTap: _addMarker,
        ),
      ),
    );
  }
}
