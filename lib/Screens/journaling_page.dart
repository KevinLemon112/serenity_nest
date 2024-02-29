import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({Key? key}) : super(key: key);

  @override
  _JournalingPageState createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  late TextEditingController _textEditingController;
  late DateTime _selectedDate;
  late bool _isDatabaseInitialized; // Flag to track initialization status
  late Database _database;
  String _journalEntry = '';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _selectedDate = DateTime.now();
    _isDatabaseInitialized = false; // Initialize flag
    _initDatabase().then((_) {
      setState(() {
        _isDatabaseInitialized = true; // Update flag when initialization completes
      });
      _loadJournalEntry();
    });
  }

  Future<void> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'journal.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE journal_entries(date TEXT PRIMARY KEY, entry TEXT)',
        );
      },
    );
  }

  Future<void> _loadJournalEntry() async {
    if (!_isDatabaseInitialized) return; // Check initialization status
    final List<Map<String, dynamic>> entries = await _database.query(
      'journal_entries',
      where: 'date = ?',
      whereArgs: ['${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'],
    );
    if (entries.isNotEmpty) {
      setState(() {
        _journalEntry = entries[0]['entry'];
        _textEditingController.text = _journalEntry;
      });
    }
  }

  Future<void> _saveJournalEntry() async {
    if (!_isDatabaseInitialized) return; // Check initialization status
    final String journalText = _textEditingController.text;
    await _database.insert(
      'journal_entries',
      {'date': '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}', 'entry': journalText},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {
      _journalEntry = journalText;
    });
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
        _loadJournalEntry();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaling'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
              padding: const EdgeInsets.all(16.0),
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
                            color: Colors.black, // Change to your preferred text color
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Write your journal entry here...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    _journalEntry,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 200), // Add extra space to prevent overflow when keyboard is opened
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
    _database.close();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: JournalingPage(),
  ));
}