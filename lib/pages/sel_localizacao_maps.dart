import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelLocalizacaoMaps extends StatefulWidget {
  final double latitudeInicial;
  final double longitudeInicial;
  const SelLocalizacaoMaps(
      {super.key,
      required this.latitudeInicial,
      required this.longitudeInicial});

  @override
  State<SelLocalizacaoMaps> createState() => _SelLocalizacaoMapsState();
}

class _SelLocalizacaoMapsState extends State<SelLocalizacaoMaps> {
  late LatLng _minhaPosicao;
  Marker? marcador;

  @override
  void initState() {
    super.initState();
    _minhaPosicao = LatLng(widget.latitudeInicial, widget.longitudeInicial);
    marcador = Marker(
      markerId: MarkerId('selected-location'),
      position: _minhaPosicao,
    );
  }

  void mapaApertado(LatLng posicao) {
    setState(() {
      _minhaPosicao = posicao;
      marcador = Marker(
        markerId: MarkerId('selected-location'),
        position: posicao,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_minhaPosicao);
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _minhaPosicao,
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        markers: marcador != null ? {marcador!} : {},
        onTap: mapaApertado,
      ),
    );
  }
}
