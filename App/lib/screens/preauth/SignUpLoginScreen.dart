import 'package:flutter/material.dart';
import '../menu/mainmenuscreen.dart';

class SignUpLoginScreen extends StatefulWidget {
  final bool initialSignUp;

  SignUpLoginScreen({Key? key, required this.initialSignUp}) : super(key: key);

  @override
  _SignUpLoginScreenState createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen> {
  late bool isSignUpScreen;
  bool agreeToTerms = false; // Added variable for checkbox state

  @override
  void initState() {
    super.initState();
    isSignUpScreen = widget.initialSignUp;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUpScreen ? 'Sign Up' : 'Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            if (isSignUpScreen) SizedBox(height: 20),
            if (isSignUpScreen)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            SizedBox(height: 0),
            if (isSignUpScreen) // Checkbox for terms and privacy policy (only for sign-up)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          agreeToTerms = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the terms of use and privacy policy',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.5),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 50),
            ElevatedButton(
              child: Text(
                isSignUpScreen ? 'Sign Up' : 'Login',
              ),
              onPressed: () {
                if (isSignUpScreen && !agreeToTerms) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Terms and Privacy Policy'),
                      content: Text(
                          'You must agree to the terms of use and privacy policy to sign up.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenuScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 0),
            if (!isSignUpScreen) // "Forgot Password?" button for login screen
              TextButton(
                child: Text('Forgot Password?'),
                onPressed: () {
                  // TODO: Implement the forgot password feature
                },
              ),
            SizedBox(height: 0), // Reduced height for a smaller gap
            TextButton(
              child: Text(
                isSignUpScreen
                    ? 'Already have an account? Login'
                    : 'Don\'t have an account? Sign Up',
              ),
              onPressed: () {
                setState(() {
                  isSignUpScreen = !isSignUpScreen;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
