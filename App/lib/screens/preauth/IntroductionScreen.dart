import 'package:flutter/material.dart';
import 'WeightHeightInputScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth_page_indicator package

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0; // Added state variable for current page

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (_currentPage != 0)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : Container(), // Empty container to remove back button on first page
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WeightHeightInputScreen()),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                color: Theme.of(context)
                    .primaryColor, // Enhanced for better visual
                fontSize: 20, // Increased font size for better visibility
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page; // Update current page index
              });
            },
            children: <Widget>[
              _buildPage(
                title: 'Welcome to CaloCam',
                description:
                    'Your smart way to track calories and nutrients in your meals.',
                image: 'assets/finallogo.png',
              ),
              _buildPage(
                title: 'Snap & Analyze',
                description:
                    'Just take a photo of your meal, and let the app analyze the nutritional content.',
                image: 'assets/finallogo.png',
              ),
              _buildPage(
                title: 'Track Your Diet',
                description:
                    'Keep track of your eating habits and maintain a healthy lifestyle.',
                image: 'assets/finallogo.png',
              ),
              _buildPage(
                title: 'Get Started Now!',
                description:
                    'Begin your journey towards a healthier diet today.',
                image: 'assets/finallogo.png',
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 4,
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Colors.grey,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5,
              ),
            ),
          ),
          if (_currentPage == 3)
            Positioned(
              bottom: 20, // Adjust the position as needed
              left: 20,
              right: 20,
              child: ElevatedButton(
                child: Text('Continue',
                    style:
                        TextStyle(fontSize: 20)), // Bigger text for the button
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeightHeightInputScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String title,
      required String description,
      required String image}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(), // Use Spacer to push content up
          Image.asset(image, height: 250), // Adjust the height as needed
          SizedBox(height: 20), // Adjust spacing as needed
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold), // Bigger title text
          ),
          SizedBox(height: 10), // Adjust spacing as needed
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18), // Bigger description text
          ),
          Spacer(flex: 2), // Provide more space at the bottom
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return Container(
      height: 50,
      width: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
    );
  }
}
