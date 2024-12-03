import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelLocalizacaoMaps extends StatefulWidget {
  const SelLocalizacaoMaps({super.key});

  @override
  State<SelLocalizacaoMaps> createState() => _SelLocalizacaoMapsState();
}

class _SelLocalizacaoMapsState extends State<SelLocalizacaoMaps> {
  double lat = -17.226550;
  double long = -46.869201;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mapa'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 11.0,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}
