import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/journal_entry_controller.dart';
import '../../database/dbhelper/journal_entries_db_helper.dart';
import '../../database/journal_entry_model.dart';
import 'single_journal_page.dart'; // This is the page for creating/editing a journal entry

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late List<JournalEntry> _journalEntries;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    _journalEntries = (await JournalEntriesDbHelper.getAllJournalEntries()).cast<JournalEntry>();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Entries'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _journalEntries.length,
        itemBuilder: (context, index) {
          final entry = _journalEntries[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date as String)),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(entry.content ?? 'No content available', maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editJournalEntry(entry),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteJournalEntry(entry.entryId!!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editJournalEntry(null),
        child: Icon(Icons.add),
      ),
    );
  }

  void _editJournalEntry(JournalEntry? entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SingleJournalPage(journalEntry: entry),
      ),
    ).then((didUpdate) {
      if (didUpdate == true) {
        // Reload your entries if the user saves changes
        // This could be reloading a list or updating the UI accordingly
      }
    });
  }

  Future<void> _deleteJournalEntry(int entryId) async {
    // Show confirmation dialog before deleting
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      await JournalEntriesDbHelper.deleteJournalEntry(entryId);
      _loadJournalEntries(); // Refresh the list after deleting an entry
    }
  }
}
