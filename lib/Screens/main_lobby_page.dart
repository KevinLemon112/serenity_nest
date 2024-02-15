import 'package:flutter/material.dart';
import 'meditation_page.dart'; // Import the MeditationPage class
import 'journaling_page.dart'; // Import the JournalingPage class
import 'quote_of_the_day_page.dart'; // Import the QuoteOfTheDayPage class
import 'resources_page.dart'; // Import the ResourcesPage class

class MainLobbyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Lobby'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to MeditationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeditationPage()),
                );
              },
              child: Text('Meditation'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to JournalingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JournalingPage()),
                );
              },
              child: Text('Journaling'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to QuoteOfTheDayPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuoteOfTheDayPage()),
                );
              },
              child: Text('Quote of the Day'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to ResourcesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResourcesPage()),
                );
              },
              child: Text('Resources'),
            ),
          ],
        ),
      ),
    );
  }
}