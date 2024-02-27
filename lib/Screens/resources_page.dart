import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: Center(
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20), // Spacer between title and buttons
                    // Button for first article
                    _buildArticleButton(
                      'https://www.medicalnewstoday.com/articles/154543',
                      'What is mental health?\nBy: Adam Felman and Rachel Ann Tee-Melegrito',
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
                style: const TextStyle(color: Colors.white),
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