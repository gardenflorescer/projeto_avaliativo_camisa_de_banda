# Catálogo de Camisas Rock Band - Flutter 🎸

Este é o projeto avaliativo do **Módulo 1** do curso **Desenvolvimento com Dart e Flutter** do **SCTEC**. O aplicativo é um catálogo interativo de camisetas de bandas de rock clássicas, contendo funcionalidades de listagem (grade/lista), filtros dinâmicos de pesquisa, e fluxo completo de fechamento de pedido com validação rigorosa de dados e simulação de envio para serviço backend em formato JSON.

---

## 🚀 Como Executar o Projeto

Para executar este projeto localmente na sua máquina, siga os passos abaixo:

### Pré-requisitos
* **Flutter SDK** instalado (versão estável mais recente recommended).
* Um emulador (Android/iOS) ou dispositivo físico conectado, ou suporte a desktop/web ativado.
* Editor de código como **VS Code** ou **Android Studio**.

### Passo a Passo

1. **Clonar o Repositório**
   ```bash
   git clone https://github.com/gardenflorescer/projeto_avaliativo_camisa_de_banda
   cd projeto_avaliacao_flutter
   ```

2. **Obter as Dependências**
   No terminal, execute o comando para baixar os pacotes necessários:
   ```bash
   flutter pub get
   ```

3. **Executar o Aplicativo**
   Inicie o aplicativo no emulador ou dispositivo conectado:
   ```bash
   flutter run
   ```

---

## 🛠️ Arquitetura e Organização de Pastas

O projeto foi estruturado seguindo boas práticas de modularidade, separando a camada de dados, modelos e interfaces de usuário (UI):

```text
lib/
├── datasources/
│   └── product_datasource.dart    # Fonte de dados estática (JSON bruto do catálogo)
├── models/
│   └── product_model.dart         # Modelo de dados e desserialização de produtos
├── screens/
│   ├── product_grid_screen.dart   # UI: Catálogo principal (Grade/Lista, buscas e filtros)
│   └── product_buy_screen.dart    # UI: Formulário de compra, regras de juros e simulação de checkout
└── main.dart                      # Ponto de entrada do app e mapeamento das rotas nomeadas
```

---

## 📋 Requisitos Técnicos Implementados

Aqui estão descritos como cada um dos **Requisitos Funcionais (RF)** e regras de negócio foram resolvidos no código-fonte:

### Camada de Dados e Modelagem
* **RF01 (Decodificação de Dados)**: No `ProductDatasource`, o JSON bruto é decodificado em uma lista dinâmica usando a função nativa `jsonDecode(rawJson)`.
* **Desserialização**: No arquivo `product_model.dart`, criamos o mapeamento `ProductModel.fromJson` para converter os mapas em instâncias tipadas.

### Tela do Catálogo (`product_grid_screen.dart`)
* **RF02 (Visualização Flexível)**: O usuário pode alternar a visualização a qualquer momento clicando no botão do AppBar, chaveando dinamicamente entre um `GridView.builder` e um `ListView.builder`.
* **RF04 (Busca e Filtro de Preços)**:
  * Campo de texto atualiza a busca no evento `onChanged` aplicando filtro case-insensitive sobre o título.
  * Dois sliders interativos controlam de forma precisa o preço mínimo e máximo (de R$ 0,00 a R$ 200,00).
* **RF05.1 (Fallback de Imagem)**: Implementamos um construtor de imagem que verifica se a URL começa com `assets/`. Caso falhe no carregamento, um widget de erro amigável é retornado com `errorBuilder`.
* **RF05.2 (Formatação Monetária)**: Todos os valores numéricos são exibidos formatados no padrão de moeda brasileiro (`R$` e substituição de ponto por vírgula em `toStringAsFixed(2)`).
* **RF05.3 (Controle de Estoque)**: Produtos indisponíveis (`disponivel: false`) mostram um rótulo "Indisponível" em vermelho, e o clique no botão de compra é bloqueado.
* **RF06 (Navegação Segura)**: A navegação ocorre através de **rotas nomeadas** (`/compra`) passando a entidade selecionada como argumento utilizando o sistema do Flutter: `Navigator.pushNamed(context, '/compra', arguments: product)`.

### Tela de Fechamento de Compra (`product_buy_screen.dart`)
* **RF07.1 e RF07.2 (Resumo do Item)**: Exibe a imagem de forma responsiva, título e o preço unitário formatados.
* **RF07.3 (Campos de Entrada)**:
  * **RF07.3.1 (Tamanho)**: Dropdown de tamanhos de P a XG.
  * **RF07.3.2 & RF08 (Quantidade Limitada)**: Selecionador incrementador de quantidade bloqueado com limites rigorosos de no mínimo 1 e no máximo 5 camisetas.
  * **RF07.3.3, RF10 & RF11 (Parcelamento e Juros)**: Dropdown com parcelamento em até 6 vezes. Aplicação matemática de **0,5% de juros adicionais** por parcela a partir da segunda parcela (ex: 1x sem juros, 2x com 0,5% de juros, 6x com 2,5% de juros no valor total).
  * **RF07.3.4 & RF07.3.5 (Dados Cadastrais)**: Inputs de texto para Nome do Comprador e Endereço de Entrega.
* **RF12 (Validação de Texto com Trim)**: Uma função limpa espaços em branco no início e fim usando `.trim()` e exige no mínimo 4 caracteres válidos nos campos textuais, impedindo o envio de entradas vazias ou insuficientes.
* **RF07.4 (Simulação de Serviço)**: No método `_processarCompra`, as informações do comprador, produto, quantidade, tamanho, parcelas e cálculos de juros são unificadas em uma entidade Map e impressas no console no formato JSON perfeitamente identado (`JsonEncoder.withIndent`).
* **RF07.5 (Feedback de Sucesso)**: Um `SnackBar` informativo de sucesso em verde é exibido por 2 segundos, seguido pelo retorno automático do usuário para a tela inicial do catálogo.

---

## 🌿 Estratégia de Branches (Git)

Para manter a organização e simular um fluxo de trabalho profissional, utilizamos a seguinte árvore de ramificações:
* **`main`**: Branch estável que contém o código homologado e pronto para produção.
* **`feature/catalogo`**: Desenvolvimento do catálogo, listagens, pesquisa, filtros de preço e alternância de visualização.
* **`feature/compra`**: Desenvolvimento do formulário de finalização de pedido, validações rígidas de campos e cálculo matemático de juros progressivos por parcelas.

---

## 📈 Melhorias Futuras Identificadas

Se tivéssemos mais tempo para evoluir o sistema, as melhorias prioritárias seriam:
1. **Gerenciamento de Estado**: Migrar o estado local (`setState`) para um padrão de gerenciamento robusto como **Bloc**, **Cubit** ou **Provider** para desacoplar a lógica de UI.
2. **Persistência de Dados**: Integrar um banco de dados local seguro como **Hive** ou **SQLite** para permitir um carrinho de compras persistente que mantém os dados salvos entre aberturas do app.
3. **Imagens Reais de Produção**: Substituir as URLs de imagens de mockup por um serviço de CDN dinâmico ou armazenamento Firebase Storage.

---

## 🎓 Desenvolvido para
**SCTEC - Serviço de Carreira Tech**  
*Trilha de Desenvolvimento de Software — Especialização em Flutter*  
Aluno: **RAYRON SOUSA MOURA**  
Data: Julho / 2026
