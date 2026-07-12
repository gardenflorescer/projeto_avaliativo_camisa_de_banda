import 'dart:convert';

class ProductDatasource {
  static const String rawJson = '''
  [
    {
      "id": 1,
      "titulo": "Camisa Polo Classic Blue",
      "preco": 89.90,
      "imagemUrl": "assets/images/alice_in_chains.jpg",
      "disponivel": true,
      "descricao": "Camisa polo clássica em algodão piquet de alta qualidade, ideal para ocasiões casuais e semi-formais."
    },
    {
      "id": 2,
      "titulo": "Camiseta Básica Minimalist Black",
      "preco": 49.90,
      "imagemUrl": "assets/images/bauhaus.jpg",
      "disponivel": true,
      "descricao": "Camiseta preta básica, 100% algodão sustentável com caimento perfeito para o dia a dia."
    },
    {
      "id": 3,
      "titulo": "Camiseta Estampa Vintage Sunset",
      "preco": 69.90,
      "imagemUrl": "assets/images/black_sabbath.jpg",
      "disponivel": true,
      "descricao": "Estampa retrô inspirada no pôr do sol californiano. Tecido leve e confortável."
    },
    {
      "id": 4,
      "titulo": "Camisa Social Slim White",
      "preco": 129.90,
      "imagemUrl": "assets/images/blind_guardian.jpg",
      "disponivel": false,
      "descricao": "Camisa social branca de corte slim fit. Elegância e sofisticação para o ambiente corporativo."
    },
    {
      "id": 5,
      "titulo": "Camiseta Oversized Streetwear",
      "preco": 79.90,
      "imagemUrl": "assets/images/helloween.jpg",
      "disponivel": true,
      "descricao": "Modelagem oversized moderna com ombros caídos. Perfeita para visuais despojados urbanos."
    },
    {
      "id": 6,
      "titulo": "Camiseta Esportiva Dry Fit",
      "preco": 59.90,
      "imagemUrl": "assets/images/rammstein.jpg",
      "disponivel": true,
      "descricao": "Tecnologia Dry Fit de secagem rápida e alta respirabilidade para atividades físicas de alta performance."
    },
    {
      "id": 7,
      "titulo": "Camisa de Botão Floral Tropical",
      "preco": 99.90,
      "imagemUrl": "assets/images/sisters_of_mercy.jpg",
      "disponivel": false,
      "descricao": "Estampa florida tropical vibrante, perfeita para o verão e dias ensolarados na praia."
    },
    {
      "id": 8,
      "titulo": "Camiseta Retrô Rock Band",
      "preco": 74.90,
      "imagemUrl": "assets/images/the_doors.jpg",
      "disponivel": true,
      "descricao": "Estilo vintage estonada com estampa de banda de rock clássica dos anos 80."
    }
  ]
  ''';

  /// Obtém e decodifica os produtos do JSON para uma lista de Maps (RF01)
  List<dynamic> getRawProducts() {
    return jsonDecode(rawJson);
  }
}