import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenlife/database/models/medicine.dart';
import 'package:zenlife/database/models/medicine_type.dart';
import '../medication_home_page.dart';
import '../success_screen/success_screen.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({Key? key}) : super(key: key);

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  MedicineType? selectedMedicineType;
  int selectedInterval = 24; // Default value
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 0); // Default value

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            TextFormField(
              controller: dosageController,
              decoration: const InputDecoration(labelText: 'Dosage in mg'),
              keyboardType: TextInputType.number,
            ),
            // Medicine Type selection
            // Interval selection
            // Time selection
            ElevatedButton(
              onPressed: submitEntry,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void initializeNotifications() {
    // Initialize your notification plugin here
  }

  void submitEntry() {
    // Handle the submission logic here, including validation and notification scheduling
    // For this example, we'll just navigate to a success screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccessScreen()),
    );
  }
}
