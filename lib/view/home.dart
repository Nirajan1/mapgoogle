import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapgoogle/model/direction_model.dart';
import 'package:mapgoogle/service/direction_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

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
  Directions? _info;
  //* Create a marker function to add and remove markers
  void _addMarker(LatLng position) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // * origin in not set OR both origin and destination is set
      // * set origin
      setState(() {
        _origin = Marker(
          flat: true,
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
        // * Reset info when user select origin
        _info = null;
      });
    } else {
      // * origin is already set
      // *  set destination
      setState(
        () {
          _destination = Marker(
            flat: true,
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
      // * Get direction
      final directions = await RemoteDirectionService().getDirections(
          origin: _origin!.position, destination: _destination!.position);
      setState(() => _info = directions);
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
                      tilt: 22.5,
                      zoom: 17.2,
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
                      tilt: 22.5,
                      zoom: 17.2,
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
            _info != null
                ? CameraUpdate.newLatLngBounds(
                    _info!.bounds!,
                    100.0,
                  )
                : CameraUpdate.newCameraPosition(_initialCameraPosition),
          ),
          child: const Icon(Icons.center_focus_strong),
        ),

        body: Stack(alignment: Alignment.center, children: [
          GoogleMap(
            compassEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            polylines: {
              if (_info != null && _info!.polylinePoints != null)
                Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 2,
                    points: _info!.polylinePoints!
                        .map((e) => LatLng(
                              e.latitude,
                              e.longitude,
                            ))
                        .toList()),
            },
            onTap: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 2),
                      blurRadius: 6.2,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
