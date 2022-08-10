import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_codigo5_maps/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _points = [];

  late GoogleMapController googleMapController;

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

  @override
  initState() {
    super.initState();
    getDataMarkers();
    currentPosition();
  }

  moveCamera() async {
    Position position = await Geolocator.getCurrentPosition();

    CameraUpdate cameraUpdate = CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    );
    googleMapController.animateCamera(cameraUpdate);
  }

  getDataMarkers() async {
    listLocation.forEach((element) async {
      //   Uint8List bytes = await imageToBytes(element["icon"], fromNetwork: true);
      //   BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);
      //   MarkerId markerId = MarkerId(_markers.length.toString());
      //   Marker marker = Marker(
      //     markerId: markerId,
      //     icon: icon,
      //     position: LatLng(element["lat"], element["lon"]),
      //   );
      //   _markers.add(marker);

      imageToBytes(element["icon"], fromNetwork: true).then((value) {
        MarkerId markerId = MarkerId(_markers.length.toString());
        Marker marker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.fromBytes(value),
          position: LatLng(element["lat"], element["lon"]),
        );
        _markers.add(marker);
        setState(() {});
      });
    });
  }

  Future<Uint8List> imageToBytes(String path,
      {int width = 100, bool fromNetwork = false}) async {
    late Uint8List bytes;

    if (fromNetwork) {
      File file = await DefaultCacheManager().getSingleFile(path);
      bytes = await file.readAsBytes();
    } else {
      ByteData byteData = await rootBundle.load(path);
      bytes = byteData.buffer.asUint8List();
    }
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    ui.FrameInfo frame = await codec.getNextFrame();

    ByteData? myByteFormat = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return myByteFormat!.buffer.asUint8List();
  }

  Future<CameraPosition> initCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
  }

  currentPosition() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId("ruta_1"),
        color: Color(0xfff72585),
        width: 5,
        points: _points,
      ),
    );

    Geolocator.getPositionStream().listen((event) {
      _points.add(
        LatLng(
          event.latitude,
          event.longitude,
        ),
      );
      CameraUpdate cameraUpdate = CameraUpdate.newLatLng(
        LatLng(
          event.latitude,
          event.longitude,
        ),
      );
      googleMapController.animateCamera(cameraUpdate);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initCurrentPosition(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: snap.data,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController googleController) {
                    // googleController.setMapStyle(json.encode(mapStyle));
                    googleMapController = googleController;
                    googleMapController.setMapStyle(json.encode(mapStyle));
                  },
                  markers: _markers,
                  polylines: _polylines,
                  onTap: (LatLng position) async {
                    MarkerId markerId = MarkerId(_markers.length.toString());
                    Marker marker = Marker(
                      markerId: markerId,
                      // icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/icons/location-icon.png'),
                      icon: BitmapDescriptor.fromBytes(
                        await imageToBytes(
                          "assets/icons/place.png",
                          width: 50,
                          fromNetwork: false,
                        ),
                      ),
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(14.0),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        moveCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff023047),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      icon: const Icon(Icons.location_on),
                      label: const Text(
                        "Mi ubicación",
                      ),
                    ),
                  ),
                ),
              ],
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
