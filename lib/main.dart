import 'package:flutter/material.dart';
import 'screens/product_grid_screen.dart';
import 'screens/product_buy_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Usando a sintaxe moderna super.key para evitar erros de versão do Dart
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Camisas Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductGridScreen(),
        '/compra': (context) => const ProductBuyScreen(),
      },
    );
  }
}