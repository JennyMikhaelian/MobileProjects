import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jenny_papas_pizzeria/pizza.dart';
import 'package:jenny_papas_pizzeria/thank_you.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Pizza pizzaOrder; // Correctly declared and accessible throughout the class

  @override
  void initState() {
    super.initState();
    // Initialize pizzaOrder with default values
    pizzaOrder = Pizza(size: 'small', flavor: 'Margherita', price: 5.0);
  }

  void updateSize(Pizza pizza) {
    setState(() {
      pizzaOrder.size = pizza.size;
      pizzaOrder.price = pizza.price; // Update price based on size
    });
  }

  void updateFlavor(String flavor) {
    setState(() {
      pizzaOrder.flavor = flavor;
    });
  }

  void updatedSelectedIngredients(List<Ingredients> selectedIngredients) {
    setState(() {
      pizzaOrder.ingredients = selectedIngredients;
    });
  }

  Future<void> submitOrder() async {
    final url = Uri.parse('http://10.0.2.2/pizza/save_order.php');
    final user_id = 1;

    final List<String> selectedIngredientsNames = pizzaOrder.ingredients
        .map((ingredient) => ingredient.ingredient)
        .toList();

    final Map<String, dynamic> orderData = {
      'user_id': user_id,
      'size': pizzaOrder.size,
      'flavor': pizzaOrder.flavor,
      'ingredients': selectedIngredientsNames,
      'total_price': pizzaOrder.totalPrice,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['error'] == null) {
      // Extract orderId from the response
      final int orderId = responseData['order_id'];

      // Use Navigator to push to the ThankYouPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ThankYouPage(orderId: orderId),
        ),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(responseData['error'] ?? 'Something went wrong.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Papa\'s Pizzeria',
            style: TextStyle(fontFamily: 'Pacifico', fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset("assets/images/pizzalogo.jpg"),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Please select your order :)',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select size', style: TextStyle(fontSize: 20)),
                    Flexible(child: MyDropdownMenuWidget(updateSize: updateSize)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select flavor', style: TextStyle(fontSize: 20)),
                    Flexible(child: MyDropdownMenuWidgetFlavor(updateFlavor: updateFlavor)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Select ingredients:', style: TextStyle(fontSize: 20)),
                IngredientsCheckboxWidget(updatedSelectedIngredients: updatedSelectedIngredients),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Receipt: ',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Your Order:\n----------------\nOne ${pizzaOrder.size} ${pizzaOrder.flavor}.\n'
                          'Note: Your total price may vary if you\'ve selected additional ingredients.'),
                      if (pizzaOrder.ingredients.isNotEmpty)
                        Text(
                          'Ingredients: ${pizzaOrder.ingredients.map((i) => i.ingredient).join(', ')}',
                        ),
                      const SizedBox(height: 8,),
                      Text(
                        'Your Total Price is: \$${pizzaOrder.totalPrice}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: submitOrder,
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
