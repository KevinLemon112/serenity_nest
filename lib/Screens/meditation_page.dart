import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});
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
  bool _soundSelected = false; // Tracks if a sound is selected

  @override
  void initState() {
    super.initState();
    _remainingTimeInSeconds = 0;
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        _audioPlayer.stop();
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
            _chosen ? _getImageForSound(_selectedSound!) : 'https://storage.prompt-hunt.workers.dev/clgipn2na0019jz08n77lxw6h_0.jpeg',
            fit: BoxFit.cover,
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
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
                            _soundSelected = true; // Indicate that a sound is selected
                          });
                        },
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        dropdownColor: Colors.black,
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
                    const SizedBox(height: 20),
                    // Render duration selection only if a sound is selected
                    if (_soundSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<int>(
                          value: _selectedDuration,
                          onChanged: (int? value) {
                            setState(() {
                              if (_chosen) {
                                _timer.cancel(); // Cancel the timer if it's running
                              }
                              _selectedDuration = value;
                              _chosen = _selectedSound != null && _selectedDuration != null;
                              if (_chosen) {
                                _remainingTimeInSeconds = _selectedDuration! * 60;
                                _startTimer();
                                _startAudio();
                              }
                            });
                          },
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          dropdownColor: Colors.black,
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
                  ],
                ),
                const SizedBox(height: 20),
                if (_chosen)
                  Column(
                    children: [
                      Text(
                        'Selected Sound: $_selectedSound',
                        style: TextStyle(
                          color: (_selectedSound == 'Rain' || _selectedSound == 'Wind') && _remainingTimeInSeconds > 0
                              ? Colors.black
                              : Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Time remaining: ${_formatDuration(_remainingTimeInSeconds)}',
                        style: TextStyle(
                          color: (_selectedSound == 'Rain' || _selectedSound == 'Wind') && _remainingTimeInSeconds > 0
                              ? Colors.black
                              : _remainingTimeInSeconds > 0 ? Colors.white : Colors.red,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Reset the timer and start audio playback
                          setState(() {
                            _remainingTimeInSeconds = _selectedDuration! * 60; // Convert minutes to seconds
                            _timer.cancel();
                            _resetAudio();
                            _startTimer();
                            _startAudio();
                          });
                        },
                        child: const Text('Reset Timer'),
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

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getImageForSound(String sound) {
    switch (sound) {
      case 'Rain':
        return 'https://images3.alphacoders.com/133/1339459.png';
      case 'Wind':
        return 'https://wallpapers.com/images/hd/wind-1920-x-1200-background-ppwgo9u9y9hr0exw.jpg';
      case 'Garden':
        return 'https://wallpapers.com/images/hd/enchanted-garden-1920-x-1080-wallpaper-ojek6zerpim27rv6.jpg';
      default:
        return 'https://www.pixelstalk.net/wp-content/uploads/images3/Star-Wallpaper-for-iPhone-8.jpg';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _resetAudio() async {
      final audioPath = _getAudioPathForSound(_selectedSound!);
      // Stop the audio if it's playing
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath!));
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
    if (_remainingTimeInSeconds > 0) {
      _timer.tick;
    }
  }

  void _startAudio() async {
    await _audioPlayer.stop();
    if (_selectedSound != null) {
      final audioPath = _getAudioPathForSound(_selectedSound!);
      if (audioPath != null) {
          await _audioPlayer.play(AssetSource(audioPath));
          await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      }
    }
  }

  String? _getAudioPathForSound(String sound) {
    switch (sound) {
      case 'Rain':
        return 'rain.mp3'; // Adjust the path based on the actual location of your audio files
      case 'Wind':
        return 'wind.mp3';
      case 'Garden':
        return 'garden.mp3';
      case 'No Noise':
        return null;
    }
    return null;
  }
}