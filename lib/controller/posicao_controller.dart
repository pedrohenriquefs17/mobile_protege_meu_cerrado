import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PosicaoController extends ChangeNotifier {
  double latitude = 0;
  double longitude = 0;
  String erro = '';

  PosicaoController() {
    getPosicao();
  }

  void atualizarPosicao(double lat, double long) {
    latitude = lat;
    longitude = long;
    notifyListeners();
  }

  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      latitude = posicao.latitude;
      longitude = posicao.longitude;
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _posicaoAtual() async {
    bool permitido;
    LocationPermission permicao;

    permitido = await Geolocator.isLocationServiceEnabled();
    if (!permitido) {
      throw 'Serviço de localização desativado';
    }

    permicao = await Geolocator.checkPermission();
    if (permicao == LocationPermission.deniedForever) {
      throw 'Permissão de localização negada';
    }

    if (permicao == LocationPermission.denied) {
      permicao = await Geolocator.requestPermission();
      if (permicao != LocationPermission.whileInUse &&
          permicao != LocationPermission.always) {
        throw 'Permissão de localização negada';
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
