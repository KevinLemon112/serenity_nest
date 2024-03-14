import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      final String newQuote = await _fetchRandomQuote();
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
        setState(() async {
          _quote = await _fetchRandomQuote();
        });
      }
    }
  }

  Future<String> _fetchRandomQuote() async {
    // Fetch a random quote from Firestore
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('quotes').get();
    final List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;
    final Random random = Random();
    final int index = random.nextInt(documents.length);
    return documents[index].get('text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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