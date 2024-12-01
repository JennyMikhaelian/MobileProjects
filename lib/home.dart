import 'package:flutter/material.dart';
import 'package:jenny_papas_pizzeria/pizza.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  late Pizza pizzaOrder; // This holds the user's full pizza order

  @override
  void initState() {
    super.initState();
    pizzaOrder = Pizza(size: 'small', flavor: 'Margherita', price: 5.0); // Initialize the order with default values
  }
// Function to update the pizza size and log the changes
  void updateSize(Pizza pizza) {
    setState(() {
      pizzaOrder.size = pizza.size;
      pizzaOrder.price = pizza.price; // Update price based on size
    });
  }

  // Function to update the pizza flavor and log the changes
  void updateFlavor(String flavor) {
    setState(() {
      pizzaOrder.flavor = flavor;
    }); // Print the updated details to the console
  }
  //functtion to update checkbox list
  void updatedSelectedIngredients(List<Ingredients> selectedIngredients){
    setState(() {
      pizzaOrder.ingredients = selectedIngredients;

    });
  }

  @override
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
                Center(
                  child: Text(
                    'Please select your order :)',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select size', style: const TextStyle(fontSize: 20)),
                    Flexible(child: MyDropdownMenuWidget(updateSize: updateSize)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select flavor', style: const TextStyle(fontSize: 20)),
                    Flexible(child: MyDropdownMenuWidgetFlavor(updateFlavor: updateFlavor)),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Select ingredients:', style: const TextStyle(fontSize: 20)),
                IngredientsCheckboxWidget(updatedSelectedIngredients: updatedSelectedIngredients),
                const SizedBox(height: 30),
                //Receipt
                Container(
                  margin: const EdgeInsets.all(16.0), // Add margin for spacing
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt: ',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Your Order:\n----------------\nOne ${pizzaOrder.size} ${pizzaOrder.flavor}.\n'
                          'Note: Your total price may vary if you\'ve selected additional ingredients.'),
                      if (pizzaOrder.ingredients.isNotEmpty) // Show ingredients if any
                        Text(
                          'Ingredients: ${pizzaOrder.ingredients.map((i) => i.ingredient).join(', ')}',
                        ),
                      SizedBox(height: 8,),
                      Text(
                        'Your Total Price is: \$${pizzaOrder.totalPrice}',
                        style: TextStyle(fontSize: 20,fontFamily: 'Poppins',fontWeight: FontWeight.bold),
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
