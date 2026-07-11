class ProductModel {
  final int id;
  final String titulo;
  final double preco;
  final String imagemUrl;
  final bool disponivel;
  final String descricao;

  ProductModel({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.imagemUrl,
    required this.disponivel,
    required this.descricao,
  });

  /// Fábrica (factory) que constrói um objeto ProductModel a partir de um Map (JSON) (RF01)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      preco: (json['preco'] as num).toDouble(),
      imagemUrl: json['imagemUrl'] as String? ?? '',
      disponivel: json['disponivel'] as bool? ?? false,
      descricao: json['descricao'] as String? ?? '',
    );
  }

  /// Converte a instância de volta para Map (para envio à camada de serviços)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'preco': preco,
      'imagemUrl': imagemUrl,
      'disponivel': disponivel,
      'descricao': descricao,
    };
  }
}