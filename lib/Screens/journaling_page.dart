import 'package:flutter/material.dart';

class JournalingPage extends StatelessWidget {
  const JournalingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaling'),
      ),
      body: const Center(
        child: Text('Journaling Page'),
      ),
    );
  }
}