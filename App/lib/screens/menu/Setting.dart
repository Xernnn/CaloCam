import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themeprovider.dart'; 
import 'ChangePersonalInfoScreen.dart'; 

class SettingsScreen extends StatefulWidget {
  final Function(String) updateAppBarTitle;

  SettingsScreen({Key? key, required this.updateAppBarTitle}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateAppBarTitle('Settings');
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildProfileHeader(context),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Change Personal Information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePersonalInfoScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_4),
            title: Text('Dark Mode'),
            subtitle: Text('Adjust your visual theme'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                setState(() {
                  themeProvider.toggleTheme(value);
                });
              },
            ),
          ),
          // Add more settings options here as needed
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person, size: 20),
        radius: 30,
      ),
      title: Text("User Name"), 
      subtitle: Text("user.email@example.com"),
    );
  }
}
