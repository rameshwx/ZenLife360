import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenlife/database/user_bmi_entry_model.dart';
import '../../database/dbhelper/user_bmi_db_helper.dart';

class SingleBMIPage extends StatefulWidget {
  final UserBMIEntry? bmiEntry;
  const SingleBMIPage({Key? key, this.bmiEntry}) : super(key: key);
  @override
  _SingleBMIPageState createState() => _SingleBMIPageState();
}

class _SingleBMIPageState extends State<SingleBMIPage> {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  DateTime? _selectedDate;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _dbHelper = UserBMIDbHelper();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: widget.bmiEntry?.weight?.toString() ?? '');
    _heightController = TextEditingController(text: widget.bmiEntry?.height?.toString() ?? '');
    _selectedDate = widget.bmiEntry?.entryDate;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');

    if (userId == null) {
      _showError("User not identified.");
      return;
    }

    if (_selectedDate == null) {
      _showError("Please select a date.");
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      _showError("Please enter valid weight and height.");
      return;
    }

    // Calculate BMI
    final double bmiValue = weight / (height * height);

    // Check if a record exists for the selected date
    final UserBMIEntry? existingEntry = await _dbHelper.getEntryByDate(_selectedDate!);
    if (existingEntry != null && (widget.bmiEntry == null || existingEntry.bmiEntryId != widget.bmiEntry!.bmiEntryId)) {
      _showError("A record already exists for this date.");
      return;
    }

    final entry = UserBMIEntry(
      bmiEntryId: widget.bmiEntry?.bmiEntryId,
      userId: userId, // Use the retrieved user ID
      weight: weight,
      height: height,
      bmiValue: bmiValue,
      entryDate: _selectedDate!,
      deleteFlag: false,
    );

    if (widget.bmiEntry == null) {
      await UserBMIDbHelper.insertBMIEntry(entry);
    } else {
      await UserBMIDbHelper.updateBMIEntry(entry);
    }

    Navigator.pop(context, true); // Indicate success and return to the previous screen
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bmiEntry == null ? 'Add BMI Record' : 'Edit BMI Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(_selectedDate == null ? 'Select Date' : _dateFormat.format(_selectedDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight in KG'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height in Meters'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord,
              child: Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }
}
