import 'package:flutter/material.dart';

//we will keep the size and flavors a
//dropdown widget sizes of the pizzas
List<pizzaSize> sizes = [
  pizzaSize('small', 5.0),
  pizzaSize('medium', 8.0),
  pizzaSize('Large', 12.0),
  pizzaSize('X-Large', 15.0),
];

//list for flavors (self explanatory)
List<String> flavors = [
  'Margherita',
  'Pepperoni',
  'Hawaiian',
  'BBQ Chicken',
  'Ranch Chicken',
  'Veggie Delight',
  'Meat Lover\'s',
  'Four Cheese',
  'Pesto Chicken',
  'Supreme',
  'Seafood'
];

//list for Ingredients and prices
List<Ingredients> ingredients = [
  //we put the name aand price because we used the keyword required
  Ingredients(ingredient: 'Extra Cheese',price: 1.5),
  Ingredients(ingredient:'Extra Sauce',price: 0.75),
  Ingredients(ingredient:'Olives', price:1.0),
  Ingredients(ingredient:'Mushrooms', price:1.2),
  Ingredients(ingredient:'Onions',price: 1.0),
  Ingredients(ingredient:'Green Peppers',price: 1.3),
  Ingredients(ingredient:'Pepperoni',price: 2.0),
  Ingredients(ingredient:'Sausage',price: 2.0),
  Ingredients(ingredient:'Bacon',price: 2.5),
  Ingredients(ingredient:'Crispy Chicken Strips',price: 2.8),
  Ingredients(ingredient:'Jalapenos',price: 1.0),
  Ingredients(ingredient:'Pineapple',price: 1.5),
  Ingredients(ingredient:'BBQ Sauce',price: 1.0),
  Ingredients(ingredient:'Ranch Sauce',price: 1.0),
  Ingredients(ingredient:'Buffalo Sauce', price:1.2),
];

//Constructors
//constructor for ingredients and their prices
class Ingredients{
  String ingredient;
  double price;
  bool isSelected;

  Ingredients({ required this.ingredient,required this.price,this.isSelected = false});
}

//constructor for the final order
class Pizza {
  String size;
  String flavor;
  double price;
  List<Ingredients> ingredients;

  // Constructor
  Pizza({required this.size, required this.flavor, required this.price, this.ingredients = const []});

  double get totalPrice {
    // Calculate total price dynamically
    //fold is to calculate the  sum of all ingredients
    //it starts with the value 0 , (sum, ingredient) => sum + ingredient.price lambda function

    return price + ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.price);
  }
}

//constructor for the price of sizes
class pizzaSize {
  String size;
  double price;

  pizzaSize(this.size, this.price);
}


//Custom Buttons
//Size dropdown
class MyDropdownMenuWidget extends StatefulWidget {
  const MyDropdownMenuWidget({required this.updateSize, super.key});
  final Function(Pizza) updateSize;
  //i always add comments to remember what happened here if i opened later on
  //manages the dropdowns state and behavior
  @override
  State<MyDropdownMenuWidget> createState() => _MyDropdownMenuWidgetState();
}

class _MyDropdownMenuWidgetState extends State<MyDropdownMenuWidget> {
  late pizzaSize selectedSize; // Store the selected size

  //default and initial values of the widget
  @override
  void initState() {
    super.initState();
    selectedSize = sizes[0]; // Default to the first size in the list
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<pizzaSize>(
      value: selectedSize, // //the dropdown displays the current
      onChanged: (pizzaSize? size) { //on change it puts the selected size
        if (size != null) {
          setState(() {
            selectedSize = size; //Update the selected size locally
          });
          widget.updateSize(
            Pizza(
              size: size.size, // Pass the selected size to the parent widget
              flavor: 'Margherita', // Default flavor, or keep previous flavor
              price: size.price, // Use the price from the selected size
            ),
          );
        }
      },
      items: sizes.map<DropdownMenuItem<pizzaSize>>((pizzaSize size) {
        return DropdownMenuItem<pizzaSize>(
          value: size,
          child: Text('${size.size} (\$${size.price.toStringAsFixed(2)})'),
        );
      }).toList(),
    );
  }
}

//Flavor drop down
class MyDropdownMenuWidgetFlavor extends StatefulWidget {
  const MyDropdownMenuWidgetFlavor({required this.updateFlavor, super.key});
  final Function(String) updateFlavor; // Accept a String for the flavor

  @override
  State<MyDropdownMenuWidgetFlavor> createState() => _MyDropdownMenuWidgetStateFlavor();
}

class _MyDropdownMenuWidgetStateFlavor extends State<MyDropdownMenuWidgetFlavor> {
  late String selectedFlavor; // Store the selected flavor

  @override
  void initState() {
    super.initState();
    selectedFlavor = flavors[0]; // Default to the first flavor in the list
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedFlavor, // Current selection
      onChanged: (String? flavor) {
        if (flavor != null) {
          setState(() {
            selectedFlavor = flavor; // Update the selected flavor
            widget.updateFlavor(flavor); // Pass the flavor back to the parent widget
          });
        }
      },
      items: flavors.map<DropdownMenuItem<String>>((String flavor) {
        return DropdownMenuItem<String>(
          value: flavor,
          child: Text(flavor),
        );
      }).toList(),
    );
  }
}

//Ingredient
class IngredientsCheckboxWidget extends StatefulWidget {
  const IngredientsCheckboxWidget({required this.updatedSelectedIngredients ,super.key});
  final Function(List<Ingredients>) updatedSelectedIngredients;

  @override
  State<IngredientsCheckboxWidget> createState() => _IngredientsCheckboxWidgetState();
}

class _IngredientsCheckboxWidgetState extends State<IngredientsCheckboxWidget> {
  //the bool? is for the current state of the checkbox and the index is the ingredient index
  void _onIngredientToggle(bool? value, int index){
    //updating the state here
    setState(() {
      ingredients[index].isSelected = value ?? false; //value represent the state of the checkbox
      //which can be true or false but since the chekbox state is nullable (bool?), the ?? false ensures that if value is null the default is false
    });
    //nofiying the parent widget of the updated new list
    //ingredient)=>ingredient.isSelected) this is a lambda function  where it i=takes ingredient and returns the value of the ingredient.isselected
    //so the function is true if ingredient.isselected is true
    //where keyword filters out whatever condition is true and leaves the elements thats true according to the condition inside
    //the where method will turn an iterable List
    widget.updatedSelectedIngredients(ingredients.where((ingredient)=>ingredient.isSelected).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients.map((ingredient) {
        int index = ingredients.indexOf(ingredient);
        return CheckboxListTile(
          title: Text('${ingredient.ingredient} (\$${ingredient.price.toStringAsFixed(2)})'),
          value: ingredient.isSelected,
          onChanged: (bool? value) => _onIngredientToggle(value, index),
        );
      }).toList(),
    );
  }
}

