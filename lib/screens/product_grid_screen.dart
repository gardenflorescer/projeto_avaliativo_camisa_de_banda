import 'package:flutter/material.dart';
import '../datasources/product_datasource.dart';
import '../models/product_model.dart';

class ProductGridScreen extends StatefulWidget {
  // Ajustado para construtor moderno super.key
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final ProductDatasource _datasource = ProductDatasource();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];

  bool _isGridView = true;
  String _searchQuery = "";
  double _minPrice = 0.0;
  double _maxPrice = 200.0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    try {
      final rawData = _datasource.getRawProducts();
      setState(() {
        _allProducts = rawData
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
        _filteredProducts = List.from(_allProducts);
      });
    } catch (e) {
      debugPrint("Erro ao carregar produtos: $e");
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesTitle = product.titulo
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final matchesPrice = product.preco >= _minPrice && product.preco <= _maxPrice;
        return matchesTitle && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Catálogo de Camisas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? "Exibir como Lista" : "Exibir como Grade",
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Pesquisar por título...",
                        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (val) {
                        _searchQuery = val;
                        _filterProducts();
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Preço Mín: R$ ${_minPrice.toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Slider(
                                value: _minPrice,
                                min: 0.0,
                                max: 200.0,
                                activeColor: Colors.blueAccent,
                                onChanged: (val) {
                                  if (val <= _maxPrice) {
                                    setState(() {
                                      _minPrice = val;
                                      _filterProducts();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Preço Máx: R$ ${_maxPrice.toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Slider(
                                value: _maxPrice,
                                min: 0.0,
                                max: 200.0,
                                activeColor: Colors.blueAccent,
                                onChanged: (val) {
                                  if (val >= _minPrice) {
                                    setState(() {
                                      _maxPrice = val;
                                      _filterProducts();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhuma camisa encontrada.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_filteredProducts[index]);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductListTile(_filteredProducts[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.grey, size: 30),
                  SizedBox(height: 4),
                  Text("Imagem Local", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 30,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildProductImage(product.imagemUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "R$ ${product.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: product.disponivel
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/compra',
                              arguments: product,
                            );
                          },
                          child: const Text("Comprar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Indisponível",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListTile(ProductModel product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: _buildProductImage(product.imagemUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R$ ${product.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: product.disponivel
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/compra',
                        arguments: product,
                      );
                    },
                    child: const Text("Comprar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Indisponível",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}