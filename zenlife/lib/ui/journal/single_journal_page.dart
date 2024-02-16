import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenlife/database/journal_entry_model.dart';
import '../../database/dbhelper/journal_entries_db_helper.dart';

class SingleJournalPage extends StatefulWidget {
  final JournalEntry? journalEntry;

  const SingleJournalPage({Key? key, this.journalEntry}) : super(key: key);

  @override
  _SingleJournalPageState createState() => _SingleJournalPageState();
}

class _SingleJournalPageState extends State<SingleJournalPage> {
  late TextEditingController _contentController;
  late JournalEntriesDbHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.journalEntry?.content ?? '');
    _dbHelper = JournalEntriesDbHelper();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not found.")));
      return;
    }

    // Use the current date for new entries or keep the existing entry's date
    final currentDate = DateTime.now();
    final dateString = DateFormat('yyyy-MM-dd').format(currentDate);

    // Check if an entry already exists for today (for new entries)
    if (widget.journalEntry == null) {
      final existingEntry = await _dbHelper.getEntryByDate(currentDate);
      if (existingEntry != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An entry already exists for today.")));
        return;
      }
    }

    JournalEntry entry = JournalEntry(
      entryId: widget.journalEntry?.entryId,
      userId: userId,
      date: dateString, // Ensure this is a DateTime object
      content: _contentController.text,
      deleteFlag: false,
      uploadFlag: widget.journalEntry?.uploadFlag ?? false,
    );

    if (widget.journalEntry == null) {
      // Insert new entry
      await JournalEntriesDbHelper.insertJournalEntry(entry);
    } else {
      // Update existing entry
      await JournalEntriesDbHelper.updateJournalEntry(entry);
    }

    Navigator.pop(context, true); // Pass true to signal that an update occurred
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Entry'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
        "Date: ${widget.journalEntry?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now())}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
