import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({Key? key}) : super(key: key);

  @override
  MeditationPageState createState() => MeditationPageState();
}

class MeditationPageState extends State<MeditationPage> {
  int? _selectedDuration; // Default duration is null
  String? _selectedSound; // Default sound is null
  bool _chosen = false; // Tracks if both duration and sound are chosen
  late Timer _timer;
  late int _remainingTimeInSeconds;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _remainingTimeInSeconds = 0;
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        _audioPlayer.stop();
        _isPlaying = false;
      }
    });
  }

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
                    ? Column(
                  children: [
                    Text(
                      'Selected Sound: $_selectedSound',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Time remaining: ${_formatDuration(_remainingTimeInSeconds)}',
                      style: TextStyle(color: _remainingTimeInSeconds > 0 ? Colors.white : Colors.red, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Reset the timer and start audio playback
                        setState(() {
                          _remainingTimeInSeconds = _selectedDuration! * 60; // Convert minutes to seconds
                          _startTimer();
                          _startAudio();
                        });
                      },
                      child: const Text('Reset Timer'),
                    ),
                  ],
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<int>(
                    value: _selectedDuration,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedDuration = value;
                        _chosen = _selectedDuration != null;
                        if (true) {
                          _remainingTimeInSeconds = _selectedDuration! * 60;
                          _startTimer();
                          _startAudio();
                        }
                      });
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 18), // Set text color and size
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
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSound,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedSound = value;
                        _chosen = _selectedSound != null && _selectedDuration != null;
                        if (_chosen) {
                          _startAudio();
                        }
                      });
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 18), // Set text color and size
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds > 0) {
        setState(() {
          _remainingTimeInSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });

    // Start the timer immediately if the remaining time is greater than 0
    if (_remainingTimeInSeconds > 0) {
      _timer.tick; // Simulate a tick to start the timer
    }
  }

  void _startAudio() async {
    if (_selectedSound != null) {
      final audioUrl = _getAudioUrlForSound(_selectedSound!);
      await _audioPlayer.play(audioUrl as dynamic);
      _isPlaying = true;
    }
  }

  String _getAudioUrlForSound(String sound) {
    // Implement logic to return the URL of the audio file associated with the selected sound
    // For example:
    switch (sound) {
      case 'Rain':
        return 'https://www.soundjay.com/nature/sounds/rain-01.mp3';
      case 'Wind':
        return 'https://www.soundjay.com/nature/sounds/wind-1.mp3';
      case 'Garden':
        return 'https://www.example.com/garden_audio.mp3';
      default:
        return ''; // Handle default case
    }
  }
}