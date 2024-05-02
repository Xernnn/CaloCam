import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChangePersonalInfoScreen extends StatefulWidget {
  @override
  _ChangePersonalInfoScreenState createState() => _ChangePersonalInfoScreenState();
}

class _ChangePersonalInfoScreenState extends State<ChangePersonalInfoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Personal Information'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
              child: _profileImage == null ? Icon(Icons.camera_alt, size: 20) : null,
              radius: 30,
            ),
            title: Text("Tap to change profile picture"),
            onTap: () async {
              final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _profileImage = pickedFile;
                });
              }
            },
          ),
          // Add more fields for personal information changes here
        ],
      ),
    );
  }
}
