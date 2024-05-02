import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

class SocialPage extends StatefulWidget {
  final Function(String) updateAppBarTitle;

  SocialPage({Key? key, required this.updateAppBarTitle}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final double carouselItemWidth = 100.0; // Set your desired width here
  final double gapBetweenItems = 8.0; // Set your desired gap size here

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double viewportFraction = (carouselItemWidth + gapBetweenItems) / screenWidth;
    viewportFraction = viewportFraction > 1.0 ? 1.0 : viewportFraction;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: _buildFeaturedCarousel(viewportFraction),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: _buildInputSection(),
            ),
            _buildSocialFeed(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel(double viewportFraction) {
    List<Map<String, dynamic>> users = [
      {'imageUrl': 'https://i.imgur.com/TK4F8jn.jpeg', 'username': 'Xern'},
      {'imageUrl': 'https://i.imgur.com/n2jyvWM.jpeg', 'username': 'NamPH'},
      {'imageUrl': 'https://i.imgur.com/QA2522V.jpeg', 'username': 'PhúcBrồ'},
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: false,
        viewportFraction: viewportFraction,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pageSnapping: true,
        pauseAutoPlayOnTouch: true,
      ),
      items: users.map((user) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: carouselItemWidth,
              margin: EdgeInsets.symmetric(horizontal: gapBetweenItems / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.network(
                      user['imageUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withAlpha(100), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        user['username'],
                        style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, shadows: <Shadow>[
                          Shadow(offset: Offset(1.0, 1.0), blurRadius: 3.0, color: Colors.black),
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.imgur.com/TK4F8jn.jpeg'), // Replace with user's image URL
            radius: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0), // Adjust for more or less rounded corners
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "What's on your diet, Xern?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Makes the text bold
                  ),
                  overflow: TextOverflow.ellipsis, // Ensures the text does not exceed the container width
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.photo_camera, color: Colors.green), // Icon for the photo/video upload
            onPressed: _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.insert_emoticon, color: Colors.yellow), // Icon for the feeling/activity
            onPressed: _pickEmoticon,
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // Handle the image file
        // You can also upload the image to your server or do any other action
      });
    }
  }

  void _pickEmoticon() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an emoticon'),
          content: Text('Emoticon picker would be implemented here'),
          // You can add a list of emoticons for the user to choose from
        );
      },
    );
  }
  Widget _buildSocialFeed() {
    List<Map<String, dynamic>> posts = generateMockPosts(5);

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(posts[index]);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['imageUrl']),
            ),
            title: Text(post['username'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(post['timeAgo']),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          Image.network(
            post['imageUrl'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(post['description']),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildInteractionIcon(Icons.thumb_up_alt_outlined, post['likes'].toString(), () {}),
                _buildInteractionIcon(Icons.mode_comment_outlined, post['comments'].toString(), () {}),
                _buildInteractionIcon(Icons.send_outlined, 'Share', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20.0),
            SizedBox(width: 8.0),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateAppBarTitle('Social');
    });
  }

  List<Map<String, dynamic>> generateMockPosts(int count) {
    List<String> descriptions = [
      'Me and the bois',
      'chomp chomp',
      'DQ da goat!',
      'Tuesday Buffet, fifth batch!',
      'Worries Go Down Better with Soup!'
    ];

    List<String> imageUrls = [
      'https://i.imgur.com/VqZlDqv.jpg',
      'https://i.imgur.com/vZBL8K4.jpg',
      'https://i.imgur.com/dsrUOS4.jpeg',
      'https://i.imgur.com/evkHuCr.jpeg',
      'https://i.imgur.com/nlRr5vn.jpeg'
    ];

    List<String> usernames = [
      'NamPHDee',
      'Phúcbrồ',
      'justaFOODLOVER',
      '250poundsandcounting',
      'healthybabe2024'
    ];

    // Ensure the list is at least as long as the count
    List<Map<String, dynamic>> posts = [];
    for (int i = 0; i < count; i++) {
      int index = i % descriptions.length; // Cycle through the lists
      posts.add({
        'username': usernames[index],
        'timeAgo': '${(i % 23) + 1}h ago', // Example to keep a variety in timeAgo
        'description': descriptions[index],
        'likes': (i % 300) + 10, // Example to provide some variability
        'comments': (i % 100) + 5, // Example to provide some variability
        'imageUrl': imageUrls[index],
      });
    }
    return posts;
  }
}
