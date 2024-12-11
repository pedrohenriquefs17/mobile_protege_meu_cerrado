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

  factory OcorrenciasModel.fromJson(Map<String, dynamic> json) {
    return OcorrenciasModel(
      descricao:
          json['descricao'] ?? '', // Adicione um valor padrão se necessário
      categoria: json['idCategoria'] ?? 0,
      data: json['dtOcorrencia'] ?? '',
      latitude: json['lat'] ?? '',
      longitude: json['lon'] ?? '',
    );
  }

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
