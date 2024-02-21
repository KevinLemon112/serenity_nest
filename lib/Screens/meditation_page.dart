import 'package:flutter/material.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  int? _selectedDuration; // Default duration is null
  String? _selectedSound; // Default sound is null
  bool _chosen = false; // Tracks if both duration and sound are chosen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            _chosen ? _getImageForSound(_selectedSound!) : 'https://wallpapercave.com/wp/wp5896397.jpg',
            fit: BoxFit.cover,
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _chosen
                    ? const SizedBox.shrink()
                    : DropdownButton<int>(
                  value: _selectedDuration,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedDuration = value;
                      _chosen = _selectedSound != null && _selectedDuration != null;
                    });
                  },
                  style: const TextStyle(color: Colors.white), // Set text color
                  dropdownColor: Colors.black, // Set dropdown background color
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text('3 Minutes'),
                    ),
                    DropdownMenuItem<int>(
                      value: 5,
                      child: Text('5 Minutes'),
                    ),
                    DropdownMenuItem<int>(
                      value: 10,
                      child: Text('10 Minutes'),
                    ),
                    DropdownMenuItem<int>(
                      value: 15,
                      child: Text('15 Minutes'),
                    ),
                    DropdownMenuItem<int>(
                      value: 20,
                      child: Text('20 Minutes'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _chosen
                    ? const SizedBox.shrink()
                    : DropdownButton<String>(
                  value: _selectedSound,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedSound = value;
                      _chosen = _selectedSound != null && _selectedDuration != null;
                    });
                  },
                  style: const TextStyle(color: Colors.white), // Set text color
                  dropdownColor: Colors.black, // Set dropdown background color
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'Rain',
                      child: Text('Rain'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Wind',
                      child: Text('Wind'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Garden',
                      child: Text('Garden'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'No Noise',
                      child: Text('No Noise'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getImageForSound(String sound) {
    switch (sound) {
      case 'Rain':
        return 'https://images3.alphacoders.com/133/1339459.png'; // Replace with the URL of your rain background image
      case 'Wind':
        return 'https://wallpapers.com/images/hd/wind-1920-x-1200-background-ppwgo9u9y9hr0exw.jpg'; // Replace with the URL of your wind background image
      case 'Garden':
        return 'https://wallpapers.com/images/hd/enchanted-garden-1920-x-1080-wallpaper-ojek6zerpim27rv6.jpg'; // Replace with the URL of your garden background image
      default:
        return 'https://www.pixelstalk.net/wp-content/uploads/images3/Star-Wallpaper-for-iPhone-8.jpg'; // Replace with the URL of your default background image
    }
  }
}