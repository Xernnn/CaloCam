import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'mealsscreen.dart';
import 'camerapage.dart';
import 'socialpage.dart';
import 'setting.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  final int totalCalories = 1859;
  final int consumedCalories = 0;
  final double gapHeight = 8.0;

  final int consumedCarbs = 0;
  final int totalCarbs = 279;

  final int consumedProtein = 0;
  final int totalProtein = 93;

  final int consumedFat = 0;
  final int totalFat = 279;

  String _appBarTitle = 'CaloCam';
  DateTime currentDate = DateTime.now();
  int cupsDrank = 0;

  void updateAppBarTitle(String newTitle) {
    setState(() {
      _appBarTitle = newTitle;
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index == 0) {
      setState(() {
        _scaffoldKey = GlobalKey<ScaffoldState>();
        updateAppBarTitle('CaloCam');
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          updateAppBarTitle('CaloCam');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _appBarTitle,
          style: TextStyle(color: Colors.white), // Make text color white
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Disables the back button or drawer icon
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.settings, color: Colors.white), onPressed: () {})
        // ], // Make icon color white
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meals',
          ),
          NavigationDestination(
            icon: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _getBody(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return MealsScreen(updateAppBarTitle: updateAppBarTitle);
      case 2:
        return CameraPage(updateAppBarTitle: updateAppBarTitle);
      case 3:
        return SocialPage(updateAppBarTitle: updateAppBarTitle);
      case 4:
        return SettingsScreen(updateAppBarTitle: updateAppBarTitle);
      default:
        return _buildHome();
    }
  }

  void _changeDate(bool isNext) {
    setState(() {
      currentDate = isNext
          ? currentDate.add(Duration(days: 1))
          : currentDate.subtract(Duration(days: 1));
    });
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime tomorrow = today.add(Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Today';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else if (dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE, dd/MM/y').format(dateTime);
    }
  }

  Widget _buildHome() {
    double consumedPercent = (consumedCalories / totalCalories).clamp(0.0, 1.0);
    int remainingCalories = totalCalories - consumedCalories;

    return Column(
      children: <Widget>[
        SizedBox(height: gapHeight),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => _changeDate(false),
              ),
              Expanded(
                child: InkWell(
                  onTap: _selectDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _formatDate(currentDate),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () => _changeDate(true),
              ),
            ],
          ),
        ),
        SizedBox(height: gapHeight),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You can still eat $remainingCalories calories',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 10, // Set the height to the desired thickness of the progress bar
                child: LinearProgressIndicator(
                  value: 1.0 - consumedPercent,
                  backgroundColor: Colors.green.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$consumedCalories calories eaten',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Goal/Limit: $totalCalories calories',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildNutrientProgressIndicators(),
            ],
          ),
        ),
        SizedBox(height: gapHeight),
        Expanded(
          flex: 3,
          child: ListView(
            children: <Widget>[
              _buildMealCard('Breakfast', 'Recommended: 371 Cal'),
              _buildMealCard('Lunch', 'Recommended: 446 Cal'),
              _buildMealCard('Dinner', 'Recommended: 520 Cal'),
              _buildMealCard('Snack', 'Recommended: 200 Cal'),
              _buildWaterTracker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientProgressIndicators() {
    final double consumedCarbsPercent = consumedCarbs / totalCarbs;
    final int remainingCarbs = totalCarbs - consumedCarbs;

    final double consumedProteinPercent = consumedProtein / totalProtein;
    final int remainingProtein = totalProtein - consumedProtein;

    final double consumedFatPercent = consumedFat / totalFat;
    final int remainingFat = totalFat - consumedFat;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildNutrientProgressBar(
            'Carbs', consumedCarbsPercent, remainingCarbs, Colors.amber),
        _buildNutrientProgressBar(
            'Protein', consumedProteinPercent, remainingProtein, Colors.brown),
        _buildNutrientProgressBar(
            'Fat', consumedFatPercent, remainingFat, Colors.orange),
      ],
    );
  }

  Widget _buildNutrientProgressBar(String nutrientName, double consumedPercent,
      int remaining, Color progressBarColor) {
    return Expanded(
      child: CircularPercentIndicator(
        radius: 45.0,
        lineWidth: 9.0,
        percent: consumedPercent,
        center: new Text(
          "${(consumedPercent * 100).toInt()}%\n$nutrientName",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          textAlign: TextAlign.center,
        ),
        footer: new Text(
          "${remaining.toString()}g left",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
          textAlign: TextAlign.center,
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: progressBarColor,
      ),
    );
  }

  Card _buildMealCard(String mealName, String calories) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.local_dining),
        title: Text(mealName),
        subtitle: Text(calories),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Navigate to CameraPage when the button is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraPage(updateAppBarTitle: updateAppBarTitle)),
            );
          },
        ),
      ),
    );
  }

  void _addCup() {
    setState(() {
      cupsDrank++;
    });
  }

  void _removeCup() {
    if (cupsDrank > 0) {
      setState(() {
        cupsDrank--;
      });
    }
  }

  Widget _buildWaterTracker() {
    // Function to build a single cup icon
    Widget _buildCupIcon(int index) {
      bool filled = index < cupsDrank;
      return IconButton(
        icon: Icon(
          filled ? Icons.local_drink : Icons.local_drink,
          color: filled ? Colors.blue : Colors.grey,
        ),
        onPressed: _addCup,
      );
    }

    // Generate a list of cup widgets based on cupsDrank
    List<Widget> cupWidgets = List.generate(
      cupsDrank + 1, // Ensure there's always one more empty cup to fill
      (index) => _buildCupIcon(index),
    );

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.local_drink),
            title: Text('Water Intake'),
            subtitle: Text('$cupsDrank/8 cups'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: _addCup,
                  tooltip: 'Add a cup',
                ),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red),
                  onPressed: _removeCup,
                  tooltip: 'Remove a cup',
                ),
              ],
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: cupWidgets,
          ),
        ],
      ),
    );
  }
}
