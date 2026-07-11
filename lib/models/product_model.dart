class ProductModel {
  final String titulo;
  final double preco;
  final List<String> tamanhosDisponiveis;
  final String imagem;
  final bool disponivel;

  ProductModel({
    required this.titulo,
    required this.preco,
    required this.tamanhosDisponiveis,
    required this.imagem,
    required this.disponivel,
  });

  // Fábrica que transforma o Mapa vindo do JSON em uma entidade ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      titulo: json['titulo'] ?? '',
      preco: (json['preco'] as num).toDouble(),
      tamanhosDisponiveis: List<String>.from(json['tamanhosDisponiveis'] ?? []),
      imagem: json['imagem'] ?? '',
      disponivel: json['disponivel'] ?? false,
    );
  }
}