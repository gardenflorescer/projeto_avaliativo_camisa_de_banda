import 'dart:convert';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  List<ProductModel> getProducts() {
    const String jsonString = '''
    [
      {
        "titulo": "Alice in Chains",
        "preco": 139.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/alice_in_chains.jpg",
        "disponivel": true
      },
      {
        "titulo": "Bauhaus",
        "preco": 119.90,
        "tamanhosDisponiveis": ["P", "M", "G"],
        "imagem": "assets/images/bauhaus.jpg",
        "disponivel": false
      },
      {
        "titulo": "Black Sabbath",
        "preco": 149.90,
        "tamanhosDisponiveis": ["PP", "P", "M", "G", "GG", "XG"],
        "imagem": "assets/images/black_sabbath.jpg",
        "disponivel": true
      },
      {
        "titulo": "Blind Guardian",
        "preco": 129.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/blind_guardian.jpg",
        "disponivel": true
      },
      {
        "titulo": "Venom",
        "preco": 129.70,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/venom.jpg",
        "disponivel": false
      },
      {
        "titulo": "Helloween",
        "preco": 129.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/helloween.jpg",
        "disponivel": true
      },
      {
        "titulo": "Carcass",
        "preco": 119.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/carcass.jpg",
        "disponivel": false
      },
      {
        "titulo": "Rammstein",
        "preco": 139.90,
        "tamanhosDisponiveis": ["M", "G", "GG"],
        "imagem": "assets/images/rammstein.jpg",
        "disponivel": true
      },
      {
        "titulo": "Sisters of Mercy",
        "preco": 119.90,
        "tamanhosDisponiveis": ["P", "M", "G"],
        "imagem": "assets/images/sisters_of_mercy.jpg",
        "disponivel": true
      },
      {
        "titulo": "The Doors",
        "preco": 109.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/the_doors.jpg",
        "disponivel": true
      },
      {
        "titulo": "The Who",
        "preco": 109.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG"],
        "imagem": "assets/images/the_who.jpg",
        "disponivel": false
      },
      {
        "titulo": "Type O Negative",
        "preco": 139.90,
        "tamanhosDisponiveis": ["P", "M", "G", "GG", "XG"],
        "imagem": "assets/images/type_o_negative.jpg",
        "disponivel": true
      }
    ]
    ''';

    // 1. Decodifica a String JSON em uma Lista dinâmica
    final List<dynamic> decodedJson = jsonDecode(jsonString);
    
    // 2. Mapeia cada item da lista usando o construtor factory do Model
    return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
  }
}