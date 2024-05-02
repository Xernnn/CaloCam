import 'package:caloriescam/screens/menu/RecognitionWrapperPage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  final Function(String) updateAppBarTitle;

  CameraPage({Key? key, required this.updateAppBarTitle}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<File> images = List<File>.filled(2, File(''), growable: false);
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getImageFromCamera(int imageIndex) async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        images[imageIndex] = File(pickedImage.path);
      });
    }
  }

  Future<void> getImagesFromGallery(int imageIndex) async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        images[imageIndex] = File(pickedImage.path);
      });
    }
  }

  Future<void> _showImageSelectionDialog(
      BuildContext context, int imageIndex) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            // Use SingleChildScrollView for content that might overflow
            child: Column(
              children: <Widget>[
                _tutorialScreen(imageIndex),
                SizedBox(height: 20), // Spacing between tutorial and buttons
                _imageSelectionButtons(context, imageIndex),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tutorialScreen(int imageIndex) {
    // Define paths and descriptions
    String gifPath = imageIndex == 0 ? 'assets/above.gif' : 'assets/lower.gif';
    String descriptionText = imageIndex == 0
        ? "Ensure to capture the food from above, covering all angles."
        : "Capture the food from a lower angle to include more details.";

    // Styling variables
    TextStyle descriptionTextStyle = TextStyle(
      fontSize: 16.0, // Adjust the font size as needed
      color: Colors.grey[800], // Adjust the color as needed
      height: 1.5, // Line height
    );
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.green, // Button background color
      onPrimary: Colors.white, // Button text color
      padding: EdgeInsets.symmetric(
          horizontal: 32.0, vertical: 12.0), // Button padding
      textStyle: TextStyle(fontSize: 18.0), // Button text style
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(gifPath), // Display the tutorial GIF
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            descriptionText,
            style: descriptionTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 0.0), // Reduced bottom padding
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the tutorial dialog
              _showSelectionOptions(
                  context, imageIndex); // Proceed to show selection options
            },
            style: buttonStyle,
            child: Text('I Understand'),
          ),
        ),
      ],
    );
  }

  void _showSelectionOptions(BuildContext context, int imageIndex) {
    // Function to show gallery and camera options after tutorial
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'galleryButton$imageIndex',
                onPressed: () {
                  getImagesFromGallery(imageIndex);
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.photo_library, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: 'cameraButton$imageIndex',
                onPressed: () {
                  getImageFromCamera(imageIndex);
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageSelectionButtons(BuildContext context, int imageIndex) {
    // This function could be repurposed or integrated directly into _showSelectionOptions
    // For simplicity, it's kept separate in this example
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Buttons go here, same as in the original _showImageSelectionDialog
      ],
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Make the modal adapt to content size
      builder: (BuildContext context) {
        return Wrap(
          // Use Wrap for responsive dialog height
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Confirm Submission',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Are you sure you want to submit these images?',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text('Cancel', style: TextStyle(fontSize: 18)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        child: Text('Submit', style: TextStyle(fontSize: 18)),
                        onPressed: () => _submitAndNavigate(context),
                        style: ElevatedButton.styleFrom(
                          primary:
                              Theme.of(context).primaryColor, // Use theme color
                          onPrimary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitAndNavigate(BuildContext context) async {
    Navigator.of(context).pop(); // Dismiss the bottom sheet immediately

    File selectedImage = images[0]; // Assuming images[0] is the selected image
    if (selectedImage.path.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecognitionWrapperPage(imageFile: selectedImage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildImageSection(0, 'Photo of Food from Above'),
          Divider(color: Colors.black, height: 2), // Divider between images
          _buildImageSection(1, 'Photo of Food Lower'),
        ],
      ),
      floatingActionButton:
          images[0].path.isNotEmpty && images[1].path.isNotEmpty
              ? FloatingActionButton(
                  // Confirmation button
                  onPressed: () => _showConfirmationDialog(context),
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                )
              : null,
    );
  }

  Widget _buildImageSection(int index, String description) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showImageSelectionDialog(context, index),
        child: Container(
          width: double.infinity,
          child: images[index].path.isNotEmpty
              ? Image.file(images[index], fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image, size: 50),
                    Text(description),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Schedule the updateAppBarTitle call after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateAppBarTitle('Camera');
    });
  }
}
