import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteOfTheDayPage extends StatefulWidget {
  const QuoteOfTheDayPage({super.key});

  @override
  _QuoteOfTheDayPageState createState() => _QuoteOfTheDayPageState();
}

class _QuoteOfTheDayPageState extends State<QuoteOfTheDayPage> {
  late String _quote = '';

  @override
  void initState() {
    super.initState();
    _updateQuote();
  }

  Future<void> _updateQuote() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastUpdateTimestamp = prefs.getInt('quote_timestamp');
    final DateTime now = DateTime.now();
    final DateTime lastUpdate =
    lastUpdateTimestamp != null ? DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp) : DateTime(1970);

    // Check if more than 24 hours have passed since last update
    if (now.difference(lastUpdate).inHours >= 24 || lastUpdate.day != now.day) {
      final String newQuote = _generateNewQuote();
      await prefs.setString('quote', newQuote);
      await prefs.setInt('quote_timestamp', now.millisecondsSinceEpoch);
      setState(() {
        _quote = newQuote;
      });
    } else {
      final String? storedQuote = prefs.getString('quote');
      if (storedQuote != null) {
        setState(() {
          _quote = storedQuote;
        });
      } else {
        setState(() {
          _quote = _generateNewQuote();
        });
      }
    }
  }

  String _generateNewQuote() {
    final Random random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  final List<String> quotes = [
    "Believe you can and you're halfway there. -Theodore Roosevelt",
    "The only way to do great work is to love what you do. -Steve Jobs",
    "Life is what happens when you're busy making other plans. -John Lennon",
    "In the end, it's not the years in your life that count. It's the life in your years. -Abraham Lincoln",
    "The only limit to our realization of tomorrow will be our doubts of today. -Franklin D. Roosevelt",
    "You are never too old to set another goal or to dream a new dream. -C.S. Lewis",
    "Spread love everywhere you go. Let no one ever come to you without leaving happier. -Mother Teresa",
    "The future belongs to those who believe in the beauty of their dreams. -Eleanor Roosevelt",
    "Success is not final, failure is not fatal: It is the courage to continue that counts. -Winston Churchill",
    "Try to be a rainbow in someone's cloud. -Maya Angelou",
    "The best way to predict the future is to create it. -Peter Drucker"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote of the Day',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1497704628914-8772bb97f450?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MnwxMDcxMTcwfHxlbnwwfHx8fHw%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.white, // Adjust text color for better readability
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: QuoteOfTheDayPage(),
  ));
}