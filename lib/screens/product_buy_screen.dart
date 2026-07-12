import 'dart:convert';
import 'package:flutter/material.dart'; // ✅ Corrigido!
import '../models/product_model.dart';

class ProductBuyScreen extends StatefulWidget {
  const ProductBuyScreen({super.key});

  @override
  State<ProductBuyScreen> createState() => _ProductBuyScreenState();
}

class _ProductBuyScreenState extends State<ProductBuyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos inputs (RF07.3)
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  String _tamanhoSelecionado = "M";
  int _quantidade = 1;
  int _parcelas = 1;

  final List<String> _tamanhos = ["P", "M", "G", "GG", "XG"];

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  // Validação conforme o RF12: Mínimo 4 caracteres sem contar espaços em branco no início e final
  String? _validarCampo(String? valor, String nomeCampo) {
    if (valor == null) return "Campo obrigatório";
    final valorFiltrado = valor.trim();
    if (valorFiltrado.length < 4) {
      return "$nomeCampo precisa de pelo menos 4 caracteres válidos.";
    }
    return null;
  }

  // Função para simular a camada de serviço (transita objeto, serializa e printa JSON, RF07.3 / 07.4)
  void _processarCompra(ProductModel product, double totalFinal, double jurosPercent) {
    // 3. Ser transitada essa entidade até a camada de serviços (caminho inverso)
    // 4. Ser impressa (print) como json na camada em serviço
    final dadosCompra = {
      "produto_id": product.id,
      "titulo": product.titulo,
      "preco_unitario": product.preco,
      "tamanho": _tamanhoSelecionado,
      "quantidade": _quantidade,
      "parcelas": _parcelas,
      "juros_aplicado": "${(jurosPercent * 100).toStringAsFixed(1)}%",
      "valor_total": double.parse(totalFinal.toStringAsFixed(2)),
      "comprador": _nomeController.text.trim(),
      "endereco": _enderecoController.text.trim(),
      "data_compra": DateTime.now().toIso8601String(),
    };

    final String jsonResult = const JsonEncoder.withIndent("  ").convert(dadosCompra);
    
    // Imprime no console (Requisito Técnico e RF07.4)
    debugPrint("=== [SERVIÇO DE COMPRA] ENVIANDO PEDIDO ===");
    debugPrint(jsonResult);
    debugPrint("==========================================");

    // 5. Mostrar snackbar de sucesso e navegar de volta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pedido realizado com sucesso! Processando..."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Após o fim do snackbar, navega de volta
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    });
  }

  // Construtor do widget da imagem com fallback automático local/remoto (RF05.1)
  Widget _buildProductImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey),
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
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recupera o produto passado por parâmetro (argumentos de rota)
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    // Cálculo da quantidade a ser comprada (RF09)
    final double precoBase = product.preco * _quantidade;

    // Cálculo de juros com base no parcelamento (RF11)
    // "Adicionar 0,5% de juros por parcela acima da primeira"
    final double taxaJuros = _parcelas > 1 ? 0.005 * (_parcelas - 1) : 0.0;
    final double totalFinal = precoBase * (1 + taxaJuros);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Compra"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Detalhes do Produto (RF07.1, RF07.2)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Imagem da camiseta
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: _buildProductImage(product.imagemUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Título e Preço Unitário
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.titulo,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Preço Unitário: R\$ ${product.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Formulário de Compra (RF07.3)
              const Text(
                "Dados da Compra",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),

              // Nome do Comprador (RF07.3.4, Validação RF12)
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: "Nome do Comprador",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => _validarCampo(val, "Nome"),
              ),
              const SizedBox(height: 12),

              // Endereço de Entrega (RF07.3.5, Validação RF12)
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: "Endereço de Entrega",
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) => _validarCampo(val, "Endereço"),
              ),
              const SizedBox(height: 16),

              // Tamanho e Quantidade
              Row(
                children: [
                  // Selecionar Tamanho (RF07.3.1)
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _tamanhoSelecionado,
                      decoration: InputDecoration(
                        labelText: "Tamanho",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: _tamanhos.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _tamanhoSelecionado = val;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Quantidade com limite de 1 a 5 (RF07.3.2, RF08)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Quantidade", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 20),
                                onPressed: _quantidade > 1
                                    ? () => setState(() => _quantidade--)
                                    : null, // Limite mínimo 1 (RF08)
                              ),
                              Text(
                                "$_quantidade",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: _quantidade < 5
                                    ? () => setState(() => _quantidade++)
                                    : null, // Limite máximo 5 (RF08)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Parcelas - Máximo 6 parcelas (RF07.3.3, RF10)
              DropdownButtonFormField<int>(
                value: _parcelas,
                decoration: InputDecoration(
                  labelText: "Forma de Pagamento",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: List.generate(6, (i) {
                  final p = i + 1;
                  final double jur = p > 1 ? 0.005 * (p - 1) : 0.0;
                  final String sufix = p == 1
                      ? "à vista (sem juros)"
                      : "$p x de R\$ ${((product.preco * _quantidade * (1 + jur)) / p).toStringAsFixed(2).replaceAll('.', ',')} "
                          "(${(jur * 100).toStringAsFixed(1)}% juros/mês)";
                  return DropdownMenuItem(
                    value: p,
                    child: Text(sufix, style: const TextStyle(fontSize: 13)),
                  );
                }),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _parcelas = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Card mostrando total da compra (RF07.4, RF09, RF11)
              Card(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.blueAccent, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal (Sem Juros):", style: TextStyle(fontSize: 14)),
                          Text(
                            "R\$ ${precoBase.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      if (_parcelas > 1) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Juros de Parcelamento (${(taxaJuros * 100).toStringAsFixed(1)}%):",
                              style: const TextStyle(fontSize: 14, color: Colors.orange),
                            ),
                            Text(
                              "+ R\$ ${(precoBase * taxaJuros).toStringAsFixed(2).replaceAll('.', ',')}",
                              style: const TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "TOTAL DA COMPRA:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "R\$ ${totalFinal.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botão para finalizar a compra (RF07.5)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processarCompra(product, totalFinal, taxaJuros);
                  }
                },
                child: const Text(
                  "Confirmar e Finalizar Compra",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
