import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_codigo5_maps/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Marker> _markers = {};

  List<Map<String, dynamic>> listLocation = [
    {
      "title": "Comisaria General",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -12.0666,
      "lon": -75.2202,
      "icon": "https://pngimg.com/uploads/police_badge/police_badge_PNG97.png",
    },
    {
      "title": "Estación de Bomberos",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -12.0696,
      "lon": -75.2085,
      "icon": "https://cdn-icons-png.flaticon.com/512/921/921079.png",
    },
    {
      "title": "Posta 1",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -12.0644,
      "lon": -75.2048,
      "icon": "https://cdn-icons-png.flaticon.com/512/4150/4150567.png",
    },
    {
      "title": "Central de Serenazgo",
      "phone": "986333222",
      "address": "Av. Lima 1234",
      "lat": -12.0645,
      "lon": -75.2074,
      "icon": "https://pngimg.com/uploads/police_badge/police_badge_PNG97.png",
    },
  ];

  // GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<CameraPosition> initCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    initCurrentPosition();

    return Scaffold(
      body: FutureBuilder(
        future: initCurrentPosition(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            return GoogleMap(
              initialCameraPosition: snap.data,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(json.encode(mapStyle2));
              },
              markers: _markers,
              onTap: (LatLng position) async {
                MarkerId markerId = MarkerId(_markers.length.toString());
                Marker marker = Marker(
                  markerId: markerId,
                  // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  icon: await BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(), 'assets/icons/location-icon.png'),
                  position: position,
                  rotation: -4,
                  draggable: true,
                  onDrag: (LatLng newPosition) {
                    print(newPosition);
                  },
                );

                _markers.add(marker);

                setState(() {});
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
