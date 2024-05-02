import 'package:flutter/material.dart';
import 'screens/wrapper.dart'; // Ensure this path is correct
import 'screens/themeprovider.dart'; // Ensure this path is correct
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CaloCam',
            home: Wrapper(),
            theme: ThemeData.light().copyWith(
              primaryColor: Color(0xFF1F7700),
              colorScheme: ColorScheme.light(
                primary: Color(0xFF1F7700),
                secondary: Color(0xFFF6F8E8),
              ),
              scaffoldBackgroundColor: Color(0xFFF6F8E8), // Light theme background color
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Color(0xFF4DBD73),
              colorScheme: ColorScheme.dark(
                primary: Color(0xFF4DBD73),
                secondary: Color(0xFF2A2B2E),
              ),
              scaffoldBackgroundColor: Color(0xFF2A2B2E), // Optional: Customize for dark theme
            ),
            themeMode: themeProvider.themeMode, // Uses system theme mode by default
          );
        },
      ),
    );
  }
}
