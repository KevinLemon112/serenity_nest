import 'package:flutter/material.dart';
import 'meditation_page.dart';
import 'journaling_page.dart';
import 'quote_of_the_day_page.dart';
import 'resources_page.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore for database interaction

class MainLobbyPage extends StatelessWidget {
  final String? userName;

  const MainLobbyPage({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: const Center(
            child: Text(
              'Main Lobby',
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Extend background behind app bar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://www.pixelstalk.net/wp-content/uploads/images3/Star-Wallpaper-for-iPhone-8.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 180.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildWelcomeMessage(),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MeditationPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.network(
                            'https://storage.prompt-hunt.workers.dev/clgipn2na0019jz08n77lxw6h_0.jpeg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Meditation'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const JournalingPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.network(
                            'https://img.goodfon.com/wallpaper/big/e/72/writing-pen-metal-paper.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Journaling'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuoteOfTheDayPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.network(
                            'https://www.ourmindfullife.com/wp-content/uploads/2020/11/Positive-quote-wallpapers-for-phone-Ourmindfullife.com-12.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Quote of\nthe Day'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResourcesPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.network(
                            'https://wallpapercave.com/wp/wp6608514.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Resources'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false, // Remove all routes below the login page
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      backgroundColor: Colors.red, // Change the button color
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white, // Change the text color
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 8.0), // Add some initial padding
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While data is loading
                return const CircularProgressIndicator(); // Placeholder widget
              } else {
                if (snapshot.hasError) {
                  return const Text('Error fetching user data'); // Show error message if any
                } else {
                  // If data is loaded successfully
                  final Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
                  final String? displayName = userData?['displayName']; // Get the displayName from the fetched data

                  // Use userName if available, otherwise use displayName
                  final String welcomeMessage = userName ?? displayName ?? 'SerenityNest User';

                  return Text(
                    '\nWelcome $welcomeMessage',
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      height: 3.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(width: 8.0), // Add some final padding
        ],
      ),
    );
  }
}
