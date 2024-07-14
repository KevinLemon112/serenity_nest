import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35, color: Colors.white), // Adjust the size as needed
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          ' Resources',
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar elevation
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true, // Extend background behind app bar
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://wallpapercave.com/wp/wp11299772.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Spacer between sections
                      // Videos section
                      const Text(
                        'Videos',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 20), // Spacer between title and buttons
                      // Button for first YouTube video
                      _buildVideoButton(
                        'https://www.youtube.com/watch?v=NQcYZplTXnQ',
                        'Mental Health Wellness Tips\nBy: Psych Hub',
                      ),
                      const SizedBox(height: 20), // Spacer between buttons
                      // Button for second YouTube video
                      _buildVideoButton(
                        'https://www.youtube.com/watch?v=IY2y6kH745A',
                        'How to Have a Better Mental Health\nBy: Pysch2Go',
                      ),
                      const SizedBox(height: 20), // Spacer between buttons
                      // Button for third YouTube video
                      _buildVideoButton(
                        'https://www.youtube.com/watch?v=w4gIJVnXhsY',
                        'The UNSPOKEN Secret To IMPROVE Mental Health!\nBy: Improvement Pill',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20), // Spacer between sections
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Spacer between sections
                      // Articles section
                      const Text(
                        'Articles',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 20), // Spacer between title and buttons
                      // Button for first article
                      _buildArticleButton(
                        'https://www.medicalnewstoday.com/articles/154543',
                        'What is mental health?\nBy: Adam Felman \nand Rachel Ann \nTee-Melegrito',
                      ),
                      const SizedBox(height: 20), // Spacer between buttons
                      // Button for second article
                      _buildArticleButton(
                        'https://www.mind.org.uk/information-support/tips-for-everyday-living/wellbeing/',
                        'How to improve your mental wellbeing\nBy: Mind.org',
                      ),
                      const SizedBox(height: 20), // Spacer between buttons
                      // Button for third article
                      _buildArticleButton(
                        'https://www.nhs.uk/mental-health/self-help/guides-tools-and-activities/five-steps-to-mental-wellbeing/',
                        '5 steps to mental wellbeing\nBy: NHS.uk',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoButton(String url, String title) {
    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red, // Customize button color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_filled, // Icon representing video player
              size: 50,
              color: Colors.white, // Icon color
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80, // Set a fixed height here
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13, // Decrease font size for the third button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleButton(String url, String title) {
    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue, // Customize button color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.article, // You can replace this with an appropriate article icon
              size: 50,
              color: Colors.white, // Icon color
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80, // Set a fixed height here
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ResourcesPage(),
  ));
}