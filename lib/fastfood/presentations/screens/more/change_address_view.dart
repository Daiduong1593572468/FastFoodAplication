import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:fastfood/common/color_extension.dart';
import 'package:fastfood/common_widget/round_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  GoogleMapController? googleMapController;
  List<LatLng> polylineCoordinates = [];
  final locations = const [
    LatLng(37.42796133580664, -122.085749655962),
  ];
  static const LatLng sourceLocation =
      LatLng(37.42796133580664, -122.085749655962);
  static const LatLng destLocation =
      LatLng(37.43296265331129, -122.08832357078792);
  Set<Marker> markers = {};
  late List<MarkerData> _customMarkers;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCGjUBxZcNPaKfZpZAa7fTyVs5e5Qo0zGY",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  @override
  void initState() {
    getPolyPoints();

    super.initState();
    _customMarkers = [
      MarkerData(
          marker:
              Marker(markerId: const MarkerId('id-1'), position: locations[0]),
          child: _customMarker('Everywhere\nis a Widgets', Colors.blue)),
    ];
  }

  _customMarker(String symbol, Color color) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Image.asset(
            'assets/img/map_pin.png',
            width: 35,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Address'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: const Text(
              'GPS',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Container(
            height: 500,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: sourceLocation,
                zoom: 14.5,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: polylineCoordinates,
                )
              },
              markers: {
                const Marker(
                    markerId: MarkerId('source'), position: sourceLocation),
                const Marker(
                    markerId: MarkerId('destination'), position: destLocation),
              },
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
          ),
          Container(
            width: 300,
            child: Divider(color: Colors.black, thickness: 1),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    Position position = await _determinePosition();

                    googleMapController?.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 14)));

                    markers.clear();

                    markers.add(Marker(
                        markerId: const MarkerId('currentLocation'),
                        position:
                            LatLng(position.latitude, position.longitude)));

                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Container(
                    child: Icon(Icons.location_on,
                        size: 24.0, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
