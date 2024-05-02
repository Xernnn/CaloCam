import 'package:flutter/material.dart';
import 'signuploginscreen.dart';

class WeightHeightInputScreen extends StatefulWidget {
  @override
  _WeightHeightInputScreenState createState() => _WeightHeightInputScreenState();
}

class _WeightHeightInputScreenState extends State<WeightHeightInputScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String gender = 'Male';
  bool isMetric = true; // Toggle between metric and imperial
  List<bool> isSelected = [true, false]; // For ToggleButtons

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void toggleUnitSystem(int index) {
    setState(() {
      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
        if (buttonIndex == index) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      }
      isMetric = index == 0; // 0 for metric, 1 for imperial
    });
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your weight';
    final weight = double.tryParse(value);
    if (weight == null) return 'Please enter a valid number';
    if (weight < 20 || weight > 200) return 'Weight must be between 20-200 kg';
    return null;
  }

  String? validateHeight(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your height';
    final height = double.tryParse(value);
    if (height == null) return 'Please enter a valid number';
    if (height < 40 || height > 220) return 'Height must be between 40-220 cm';
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your age';
    final age = int.tryParse(value);
    if (age == null) return 'Please enter a valid number';
    if (age < 5 || age > 105) return 'Age must be between 5-105 years';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ToggleButtons(
                    borderColor: Colors.grey,
                    fillColor: Theme.of(context).colorScheme.primary,
                    borderWidth: 2,
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Metric Units'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Imperial Units'),
                      ),
                    ],
                    onPressed: toggleUnitSystem,
                    isSelected: isSelected,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                  suffixText: isMetric ? 'kg' : 'lbs',
                  border: OutlineInputBorder(),
                ),
                validator: validateWeight,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isMetric ? 'Height (cm)' : 'Height (feet/inches)',
                  suffixText: isMetric ? 'cm' : 'ft/in',
                  border: OutlineInputBorder(),
                ),
                validator: isMetric ? validateHeight : null, // Validate height in metric only for simplicity
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  suffixText: 'years',
                  border: OutlineInputBorder(),
                ),
                validator: validateAge,
              ),
              SizedBox(height: 20),
              Text('Gender:', style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('Male'),
                      leading: Radio<String>(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Female'),
                      leading: Radio<String>(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Continue'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Only navigate if the form is valid
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpLoginScreen(initialSignUp: true)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You can change this information in settings later on.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
