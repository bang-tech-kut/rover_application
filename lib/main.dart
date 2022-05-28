import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

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


Set<Marker> _createMarker(double lat, double lng) {
  return {
    Marker(
      markerId: MarkerId("marker_1"),
      position: LatLng(lat, lng),
    ),
  };
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kKUT = CameraPosition(
    target: LatLng(33.6206587, 133.7196255),
    zoom: 17,
  );

  Future _currentLocation() async {
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
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getPosition(),
      child: Scaffold(
        body: Consumer<MainModel>(builder: (context, model, child) {
          final lat = model.lat;
          final lon = model.lon;
           return GoogleMap(
             mapType: MapType.terrain,
             markers: _createMarker(lat, lon),
             initialCameraPosition: _kKUT,
             onMapCreated: (GoogleMapController controller) {
               _controller.complete(controller);
               },
           );
        }),
        floatingActionButton: FloatingActionButton.extended(
          // ボタン押されたらカレントロケーションメソッドへ
          onPressed: _currentLocation,
          label: Text('CurrentLocation'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

}