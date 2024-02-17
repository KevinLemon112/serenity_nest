import 'package:flutter/material.dart';
import 'meditation_page.dart'; // Import the MeditationPage class
import 'journaling_page.dart'; // Import the JournalingPage class
import 'quote_of_the_day_page.dart'; // Import the QuoteOfTheDayPage class
import 'resources_page.dart'; // Import the ResourcesPage class

class MainLobbyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set the preferred height of the app bar
        child: Container(
          padding: EdgeInsets.only(top: 1.0), // Adjust top padding here
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://wallpapercave.com/wp/wp5896397.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              'Main Lobby',
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white or any other desired color
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://www.pixelstalk.net/wp-content/uploads/images3/Star-Wallpaper-for-iPhone-8.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 200.0), // Adjust the top padding
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8), // Adjust the padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://storage.prompt-hunt.workers.dev/clgipn2na0019jz08n77lxw6h_0.jpeg', // Replace with actual meditation image URL
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Meditation'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to JournalingPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JournalingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8), // Adjust the padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://img.goodfon.com/wallpaper/big/e/72/writing-pen-metal-paper.jpg', // Replace with actual journaling image URL
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Journaling'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to QuoteOfTheDayPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuoteOfTheDayPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8), // Adjust the padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://www.ourmindfullife.com/wp-content/uploads/2020/11/Positive-quote-wallpapers-for-phone-Ourmindfullife.com-12.jpg', // Replace with actual quote of the day image URL
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Quote of\nthe Day'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to ResourcesPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResourcesPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8), // Adjust the padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://wallpapercave.com/wp/wp6608514.jpg', // Replace with actual resources image URL
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Resources'),
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
}