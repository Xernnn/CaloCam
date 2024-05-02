import 'dart:io';
import 'package:flutter/material.dart';

class IngredientRecognitionPage extends StatefulWidget {
  final File ingredientImage;

  IngredientRecognitionPage({Key? key, required this.ingredientImage}) : super(key: key);

  @override
  _IngredientRecognitionPageState createState() => _IngredientRecognitionPageState();
}

class _IngredientRecognitionPageState extends State<IngredientRecognitionPage> {
  final List<IngredientItem> _ingredients = [
    IngredientItem(
      name: 'Rice',
      weight: 200,
      imagePath: 'assets/food/rice.jpg',
      calories: 130,
      volume: 200,
      nutrients: 'Carbohydrates, Iron',
    ),
    IngredientItem(
      name: 'Fried Chicken',
      weight: 138,
      imagePath: 'assets/food/friedchicken.jpg',
      calories: 290,
      volume: 0,
      nutrients: 'Protein, Fat',
    ),
    IngredientItem(
      name: 'Cherry Tomatoes',
      weight: 16,
      imagePath: 'assets/food/tomato.jpg', // Placeholder path
      calories: 3, // Example calories for the serving
      volume: 15, // Volume in milliliters, if applicable
      nutrients: 'Vitamin C, Potassium',
    ),
    IngredientItem(
      name: 'Lettuce',
      weight: 27,
      imagePath: 'assets/food/lettuce.jpg', // Placeholder path
      calories: 5, // Example calories for the serving
      volume: 27, // Volume in milliliters, might not be applicable
      nutrients: 'Vitamin K, Folate',
    ),
    IngredientItem(
      name: 'Salad Mix',
      weight: 18,
      imagePath: 'assets/food/mix.jpg', // Placeholder path
      calories: 15, // Example calories for the serving
      volume: 0, // Not applicable for solid mix
      nutrients: 'Fiber, Vitamin A, Vitamin C',
    ),
    // Add more ingredients as needed...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text('Ingredient Recognition'),
        centerTitle: true,
        elevation: 0, 
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePreview(),
            _buildIngredientList(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/segmented.png', fit: BoxFit.cover),
    );
  }

  Widget _buildIngredientList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // To nest inside another scroll view
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = _ingredients[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Optional: adds rounded corners
              child: Image.asset(
                ingredient.imagePath,
                width: 64, // Normalize the width to 64 pixels
                height: 64, // Normalize the height to 64 pixels
                fit: BoxFit.cover, // Cover the box without changing the aspect ratio
              ),
            ),
            title: Text(ingredient.name),
            subtitle: Text('${ingredient.nutrients}\n${ingredient.calories} kcal'),
            trailing: Text('${ingredient.weight}g'),
            onTap: () {
              // Implement action on tap, such as showing a detailed page or dialog
            },
          ),
        );
      },
    );
  }
}


class IngredientItem {
  String name;
  double weight; // in grams
  String imagePath;
  double calories; // per serving
  double volume; // in milliliters, optional based on ingredient
  String nutrients; // Brief description of key nutrients

  IngredientItem({
    required this.name,
    required this.weight,
    required this.imagePath,
    required this.calories,
    required this.volume,
    required this.nutrients,
  });
}


