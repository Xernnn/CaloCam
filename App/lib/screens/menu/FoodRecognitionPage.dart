import 'package:flutter/material.dart';
import 'dart:io';

class FoodRecognitionPage extends StatefulWidget {
  final File foodImage;

  FoodRecognitionPage({Key? key, required this.foodImage}) : super(key: key);

  @override
  _FoodRecognitionPageState createState() => _FoodRecognitionPageState();
}

class _FoodRecognitionPageState extends State<FoodRecognitionPage> {
  // Dropdown menu selections
  String selectedMealType = 'Breakfast';

  // Example food item
  // Example initialization with direct values
  FoodItem _recognizedFoodItem = FoodItem(
    name: 'Fried Chicken Meal Set',
    calories: 443, // Directly providing the total calories
    carbs: 131.0, // Directly providing the total carbs
    protein: 78.0, // Directly providing the total protein
    fat: 37.0, // Directly providing the total fat
    volume: 399.0, // Directly providing the volume
  );

  final List<String> mealTypeOptions = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    // Add more meal types as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recognition'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePreview(),
            _buildNutritionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/food.jpg', fit: BoxFit.cover),
    );
  }

  Widget _buildNutritionalInfo() {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Text(
            _recognizedFoodItem.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            '${_recognizedFoodItem.calories.toStringAsFixed(0)} kcal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _nutritionalValue(
                  '${_recognizedFoodItem.carbs.toStringAsFixed(0)}g', 'Carbs'),
              _nutritionalValue(
                  '${_recognizedFoodItem.protein.toStringAsFixed(0)}g',
                  'Protein'),
              _nutritionalValue(
                  '${_recognizedFoodItem.fat.toStringAsFixed(0)}g', 'Fat'),
              _nutritionalValue(
                  '${_recognizedFoodItem.volume.toStringAsFixed(0)}g', 'Total'),
            ],
          ),
          SizedBox(height: 12.0),
          _buildDropdown(mealTypeOptions, selectedMealType, (String? newValue) {
            setState(() {
              selectedMealType = newValue!;
            });
          }),
          Divider(color: Colors.grey),
          SizedBox(height: 12.0),
          _buildCalorieBurnInfo(),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Incorrect Food'),
                        content:
                            Text('Please provide feedback on the recognition.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Incorrect Food'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add action to add this food to the diary
                },
                child: Text('Add to diary'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionalValue(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildDropdown(List<String> options, String currentValue,
      ValueChanged<String?> onChanged) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 24,
          elevation: 16,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildCalorieBurnInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _calorieBurnMethod('walk', 143), // Keep the existing methods for comparison
          _calorieBurnMethod('bike', 126),
          _calorieBurnMethod('run', 57), // Add running
          _calorieBurnMethod('swim', 48), // Add swimming
        ],
      ),
    );
  }

  Widget _calorieBurnMethod(String activity, int minutes) {
    IconData icon;
    switch (activity) {
      case 'walk':
        icon = Icons.directions_walk;
        break;
      case 'bike':
        icon = Icons.directions_bike;
        break;
      case 'run':
        icon = Icons.directions_run; // Assuming you want to use a running icon
        break;
      case 'swim':
        icon = Icons.pool; // Assuming you want to use a swimming icon
        break;
      default:
        icon = Icons.error; // Fallback icon
    }
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 4.0),
        Text('${minutes.toString()} min'),
      ],
    );
  }
}

class FoodItem {
  String name;
  double calories; // Direct value for calories
  double carbs; // Direct value for carbs
  double protein; // Direct value for protein
  double fat; // Direct value for fat
  double volume; // Direct value for volume

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.volume,
  });
}