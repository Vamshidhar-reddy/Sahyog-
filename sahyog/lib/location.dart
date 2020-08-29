import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(Location());

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position _currentPosition;
  final Map<String, Marker> _markers = {};
  Marker marker;
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

        setState(() {
          _markers.clear();
          final marker = Marker(
            markerId: MarkerId("curr_loc"),
            position:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            infoWindow: InfoWindow(title: 'Your Location'),
          );
          _markers["Current Location"] = marker;
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Your Current Location"),
        ),
        body: _currentPosition != null
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  zoom: 11,
                ),
                markers: _markers.values.toSet(),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
            : Center(child: CircularProgressIndicator()));
  }
}
