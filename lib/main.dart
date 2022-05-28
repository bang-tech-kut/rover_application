import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

Set<Marker> _createMarker(double lat, double lng) {
  return {
    Marker(
      markerId: MarkerId("marker_1"),
      position: LatLng(lat, lng),
    ),
  };
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kKUT = CameraPosition(
    target: LatLng(33.6206587, 133.7196255),
    zoom: 17,
  );

  void _currentLocation() async {
    final snapshot = FirebaseFirestore.instance
        .collection('place')
        .doc('vRv58PHrLZ0FPQKmZ1If')
        .get();
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = Null as LocationData;
    }
    double currentlat = currentLocation.latitude!;
    double currentlong = currentLocation.longitude!;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
       bearing: 0,
       target: LatLng(currentlat, currentlong),
       zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        markers: _createMarker(33.6206587, 133.7196255),
        initialCameraPosition: _kKUT,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // ボタン押されたらカレントロケーションメソッドへ
        onPressed: _currentLocation,
        label: Text('CurrentLocation'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

}