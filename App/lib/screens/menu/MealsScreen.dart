import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MealsScreen extends StatefulWidget {
  final Function(String) updateAppBarTitle;

  MealsScreen({required this.updateAppBarTitle});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateAppBarTitle('Recommended Meals');
    });
  }

  final List<Map<String, dynamic>> vietnameseMeals = [
    // Make sure to replace 'assets/finallogo.png' with actual meal images
    {'name': 'Pho', 'calories': '350', 'image': 'assets/pho.png'},
    {'name': 'Banh Mi', 'calories': '400', 'image': 'assets/banh_mi.png'},
    {'name': 'Goi Cuon', 'calories': '250', 'image': 'assets/goi_cuon.png'},
  ];

  void _navigateToMealDetail(Map<String, dynamic> meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(meal: meal),
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return GestureDetector(
      onTap: () => _navigateToMealDetail(meal),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(meal['image'], fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    meal['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Calories: ${meal['calories']}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Wrap the CarouselSlider in a Center widget
        child: CarouselSlider.builder(
          itemCount: vietnameseMeals.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return _buildMealCard(vietnameseMeals[itemIndex]);
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.6,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
        ),
      ),
    );
  }
}

class MealDetailScreen extends StatefulWidget {
  final Map<String, dynamic> meal;

  MealDetailScreen({required this.meal});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  int portionMultiplier = 1; // Default portion size is 1x

  // Example nutritional information
  final double caloriesPerPortion = 280.0;
  final double carbsPerPortion = 60.0;
  final double proteinPerPortion = 74.0;
  final double fatPerPortion = 17.0;

  // Example burn rates (calories per minute)
  final int walkBurnRate = 4;
  final int cycleBurnRate = 6;

  // Portion size and meal type selection
  int portionSize = 1;
  String selectedUnit = 'bowl (650g)';
  String selectedMeal = 'Breakfast';
  List<String> units = [
    'bowl (650g)',
    'slice (30g)',
    'cup (150g)',
  ]; // Add more units as necessary
  List<String> meals = ['Breakfast', 'Lunch', 'Dinner', 'Snack']; // Meal types

  // Method to calculate burn times
  Map<String, int> calculateBurnTimes(double calories) {
    return {
      'walk': (calories / walkBurnRate).ceil(),
      'cycle': (calories / cycleBurnRate).ceil(),
    };
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total nutritional values based on the portion multiplier
    double totalCalories = caloriesPerPortion * portionMultiplier;
    double totalCarbs = carbsPerPortion * portionMultiplier;
    double totalProtein = proteinPerPortion * portionMultiplier;
    double totalFat = fatPerPortion * portionMultiplier;

    // Calculate burn times based on total calories
    Map<String, int> burnTimes = calculateBurnTimes(totalCalories);

    TextEditingController portionController =
        TextEditingController(text: portionMultiplier.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal['name']),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(widget.meal['image'], height: 200, fit: BoxFit.cover),
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Pho',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        NutrientWidget(
                            label: 'Calories',
                            value: totalCalories.toStringAsFixed(1)),
                        NutrientWidget(
                            label: 'Carbs (g)',
                            value: totalCarbs.toStringAsFixed(1)),
                        NutrientWidget(
                            label: 'Protein (g)',
                            value: totalProtein.toStringAsFixed(1)),
                        NutrientWidget(
                            label: 'Fat (g)',
                            value: totalFat.toStringAsFixed(0)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: portionController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: false),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          int? newMultiplier =
                                              int.tryParse(value);
                                          if (newMultiplier != null) {
                                            setState(() {
                                              portionMultiplier = newMultiplier;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Text(
                                      ' x ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedUnit,
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedUnit = newValue!;
                                        });
                                      },
                                      items: units
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedMeal,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMeal = newValue!;
                                  });
                                },
                                items: meals.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(Icons.directions_walk),
                            Text('${burnTimes['walk']} min'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.directions_bike),
                            Text('${burnTimes['cycle']} min'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement 'Add to diary' functionality
                      },
                      child: Text('Add to diary'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Button background color
                        onPrimary: Colors.white, // Button text color
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A custom widget to display nutrients in the desired format
class NutrientWidget extends StatelessWidget {
  final String label;
  final String value;

  const NutrientWidget({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
