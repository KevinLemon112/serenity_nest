import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({Key? key}) : super(key: key);

  @override
  _JournalingPageState createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  late TextEditingController _textEditingController;
  late DateTime _selectedDate;
  late bool _isDatabaseInitialized; // Flag to track initialization status
  late String _userId; // Logged-in user's ID
  late CollectionReference _journalEntriesCollection;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _selectedDate = DateTime.now();
    _isDatabaseInitialized = false;
    _initUser();
  }

  Future<void> _initUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _journalEntriesCollection = FirebaseFirestore.instance.collection('users').doc(_userId).collection('journalEntries');
        _isDatabaseInitialized = true;
      });
      await _loadJournalEntryForDate(_selectedDate); // Load journal entry for the selected date
    }
  }

  Future<void> _loadJournalEntryForDate(DateTime date) async {
    if (!_isDatabaseInitialized) return;

    // Load the journal entry document for the given date
    final DocumentSnapshot<Object?> entrySnapshot = await _journalEntriesCollection.doc(_getDateString(date)).get();
    if (entrySnapshot.exists) {
      final Map<String, dynamic>? data = entrySnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('entry')) {
        // Convert Firestore Timestamp to DateTime
        final DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

        // Check if the loaded entry's date matches the selected date
        if (_getDateString(timestamp) == _getDateString(date)) {
          setState(() {
            _textEditingController.text = data['entry'];
          });
        } else {
          setState(() {
            _textEditingController.text = ''; // Set text to empty if no entry exists for this date
          });
        }
      }
    } else {
      setState(() {
        _textEditingController.text = ''; // Set text to empty if no entry exists for this date
      });
    }
  }

  Future<void> _saveJournalEntry() async {
    if (!_isDatabaseInitialized) return;
    final String journalText = _textEditingController.text;

    // Save the entry with selected date as the key
    await _journalEntriesCollection.doc(_getDateString(_selectedDate)).set({
      'entry': journalText,
      'timestamp': _selectedDate, // Use selected date instead of DateTime.now()
    });

    setState(() {
      _textEditingController.text = journalText; // Update local state
    });
  }

  String _getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadJournalEntryForDate(_selectedDate); // Load journal entry for the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend background behind app bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 37, color: Colors.black), // Adjust the size as needed
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Journaling',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar elevation
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/736x/b5/7a/d4/b57ad4feb1bc7dae03cac241c752c924.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 112.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                  const SizedBox(height: 0),
                  TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Write your journal entry here...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0), // Set the border color and thickness
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 17),
                  ElevatedButton(
                    onPressed: _saveJournalEntry,
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Journal Entry:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _textEditingController.text,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}