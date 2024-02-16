import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenlife/database/dbhelper/user_bmi_db_helper.dart'; // Adjust the import path as necessary
import 'package:zenlife/database/user_bmi_entry_model.dart';
import 'package:zenlife/ui/bmi/single_bmi.dart'; // Adjust the import path as necessary

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final UserBMIDbHelper _dbHelper = UserBMIDbHelper();
  List<UserBMIEntry> _bmiEntries = [];

  @override
  void initState() {
    super.initState();
    _loadBMIEntries();
  }

  Future<void> _loadBMIEntries() async {
    final entries = await UserBMIDbHelper.getAllBMIEntries();
    setState(() {
      _bmiEntries = entries.where((entry) => entry.deleteFlag == false).toList();
    });
  }

  Future<void> _deleteBMIEntry(int id) async {
    // Here, instead of deleting, we update the deleteFlag to true (soft delete)
    await UserBMIDbHelper.updateBMIEntry(UserBMIEntry(bmiEntryId: id, deleteFlag: true));
    _loadBMIEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Records"),
      ),
        body: ListView.builder(
          itemCount: _bmiEntries.length,
          itemBuilder: (context, index) {
            final entry = _bmiEntries[index];
            return Card( // Wrap each item in a Card widget for a polished look
              margin: EdgeInsets.all(8.0), // Add some margin around each card
              child: ListTile(
                // Use ListTile for easy layout and readability
                title: Text(
                  "Date: ${entry.entryDate != null ? DateFormat('yyyy-MM-dd').format(entry.entryDate!) : 'No Date'}",
                  style: TextStyle(fontWeight: FontWeight.bold), // Make the date bold
                ),
                subtitle: Text(
                  "Weight: ${entry.weight} kg, Height: ${entry.height} m, BMI: ${entry.bmiValue?.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.grey[600]), // Slightly muted text color
                ),
                trailing: Wrap(
                  spacing: 12, // Space between buttons
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue), // Color the edit icon
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SingleBMIPage(bmiEntry: entry)),
                        ).then((value) {
                          if (value == true) {
                            _loadBMIEntries();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Color the delete icon
                      onPressed: () {
                        // Implement deletion logic
                        _confirmDeletion(entry.bmiEntryId!!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SingleBMIPage()),
          ).then((value) {
            // If value is true, reload BMI entries to reflect changes
            if (value == true) {
              _loadBMIEntries();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDeletion(int entryId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (result == true) {
      await UserBMIDbHelper.markEntryAsDeleted(entryId);
      _loadBMIEntries();
    }
  }
}
