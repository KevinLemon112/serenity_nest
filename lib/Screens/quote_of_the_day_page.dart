import 'package:flutter/material.dart';

class QuoteOfTheDayPage extends StatelessWidget {
  const QuoteOfTheDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
      ),
      body: const Center(
        child: Text('Quote of the Day Page'),
      ),
    );
  }
}