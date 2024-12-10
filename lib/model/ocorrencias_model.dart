class OcorrenciasModel {
  final String descricao;
  final int categoria;
  final String data;
  final String latitude;
  final String longitude;

  OcorrenciasModel(
      {required this.descricao,
      required this.categoria,
      required this.data,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'decricao': descricao,
      'idCategoria': categoria,
      'dtOcorrencia': data,
      'lat': latitude,
      'lon': longitude,
    };
  }
}
