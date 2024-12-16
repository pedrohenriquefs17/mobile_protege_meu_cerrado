class OcorrenciasModel {
  final String descricao;
  final int categoria;
  final String dataOcorrencia;
  final String latitude;
  final String longitude;

  OcorrenciasModel(
      {required this.descricao,
      required this.categoria,
      required this.dataOcorrencia,
      required this.latitude,
      required this.longitude});

  factory OcorrenciasModel.fromJson(Map<String, dynamic> json) {
    return OcorrenciasModel(
      descricao:
          json['descricao'] ?? '', // Adicione um valor padrão se necessário
      categoria: json['idCategoria'] ?? 0,
      dataOcorrencia: json['dtOcorrencia'] ?? '',
      latitude: json['lat'] ?? '',
      longitude: json['lon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'idCategoria': categoria,
      'dtOcorrencia': dataOcorrencia,
      'lat': latitude,
      'lon': longitude,
    };
  }
}
