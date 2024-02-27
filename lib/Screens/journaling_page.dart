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
      body: SingleChildScrollView(
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
              TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write your journal entry here...',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveJournalEntry,
                child: Text('Save'),
              ),
              SizedBox(height: 20),
              Text(
                'Journal Entry:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_journalEntry),
            ],
          ),
        ),
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
  runApp(MaterialApp(
    home: JournalingPage(),
  ));
}