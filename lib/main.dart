import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'azure_openai_service.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'AI Assisted Groceries Cart',
        home: Scaffold(
          appBar: AppBar(
            title: Text("AI Assisted Groceries Cart"),
            ),
          body: HomePage(),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var scannerInput = TextEditingController();
  var nutricionalFacts = "";
  var recipe = "";
  var productsList = [];

  void addProductToCart(String product) {
    productsList.add(product);
    scannerInput.clear();
    notifyListeners();
  }

  void clearCart() {
    productsList.clear();
    clearAll();
    notifyListeners();
  }

  void clearAll() {
    productsList.clear();
    nutricionalFacts = "";
    recipe = "";
    scannerInput.clear();
    notifyListeners();
  }

  void generateNutriFacts() async {
    var nutriFacts = await fetchNutriFacts(productsList);
    nutricionalFacts = nutriFacts.choices;
    notifyListeners();
  }

  void generateRecipe() async {
    var nutriFacts = await fetchRecipe(productsList);
    recipe = nutriFacts.choices;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var productsList = appState.productsList;
    var nutriFacts = appState.nutricionalFacts;
    var recipe = appState.recipe;

    return SingleChildScrollView(
      child: Column(
        children: [
          Scanner(appState: appState),
          ButtonBarCartActions(appState: appState),
          if (productsList.isNotEmpty)
            ProductsTable(productsList: productsList),
          if (productsList.length > 2) ButtonBarAIActions(appState: appState),
          if (nutriFacts.isNotEmpty)
            NutricionalDataContainer(nutriFacts: nutriFacts),
          if (recipe.isNotEmpty) RecipeContainer(recipe: recipe)
        ],
      ),
    );
  }
}

class Scanner extends StatelessWidget {
  const Scanner({
    Key? key,
    required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        controller: appState.scannerInput,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Scan your product',
          icon: Icon(Icons.input, color: Colors.blue, size: 30),
        ),
        onEditingComplete: () =>
            appState.addProductToCart(appState.scannerInput.text),
      ),
    );
  }
}

class ButtonBarCartActions extends StatelessWidget {
  const ButtonBarCartActions({
    Key? key,
    required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          print('button pressed!');
          appState.addProductToCart(appState.scannerInput.text);
        },
        child: Icon(Icons.add),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          appState.clearCart();
        },
        child: Icon(Icons.delete),
      )
    ]);
  }
}


class ProductsTable extends StatelessWidget {
  const ProductsTable({
    Key? key,
    required this.productsList,
  }) : super(key: key);

  final List productsList;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Product',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Quantity',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Price',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: List<DataRow>.generate(
        productsList.length,
        (int index) => DataRow(
          cells: <DataCell>[
            DataCell(Text(productsList[index])),
            DataCell(Text('1')),
            DataCell(Text('€3.99')),
          ],
        ),
      ),
    );
  }
}

class ButtonBarAIActions extends StatelessWidget {
  const ButtonBarAIActions({
    Key? key,
    required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.end, children: [
      
      FloatingActionButton(
        onPressed: () {
          appState.generateNutriFacts();
        },
        tooltip: 'Get nutricional facts by AI',
        child: Icon(Icons.lightbulb_outline),
      ),

      FloatingActionButton(
        onPressed: () {
          appState.generateRecipe();
        },
        tooltip: 'Get recipe by AI',
        child: Icon(Icons.receipt_long_rounded),
      ),
    ]);
  }
}


class RecipeContainer extends StatelessWidget {
  const RecipeContainer({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final String recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      // width: 500,
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        animatedTexts: [
          TyperAnimatedText(recipe.trim(), speed: Duration(milliseconds: 40)),
        ],
      ),
    );
  }
}

class NutricionalDataContainer extends StatelessWidget {
  const NutricionalDataContainer({
    Key? key,
    required this.nutriFacts,
  }) : super(key: key);

  final String nutriFacts;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      // width: 500,
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        animatedTexts: [
          TyperAnimatedText(nutriFacts.trim(),
              speed: Duration(milliseconds: 40)),
        ],
      ),
    );
  }
}