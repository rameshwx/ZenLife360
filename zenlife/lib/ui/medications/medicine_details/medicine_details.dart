import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenlife/database/models/medicine.dart';

class MedicineDetails extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetails({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main information section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon
                SvgPicture.asset(
                  'assets/icons/${medicine.medicineType?.toLowerCase()}.svg',
                  width: 100, // Adjust according to your size
                ),
                // Medicine name and dosage
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medicine Name: ${medicine.medicineName}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Dosage: ${medicine.dosage} mg',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Extended information section
            Text(
              'Medicine Type: ${medicine.medicineType}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              'Interval: Every ${medicine.interval} hours',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              'Start Time: ${medicine.startTime}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            // Delete button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Button background color
              ),
              onPressed: () {
                // Handle delete action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Return AlertDialog for confirmation
                    return AlertDialog(
                      title: Text('Confirm'),
                      content: Text('Do you want to delete this medicine?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle delete logic
                            Navigator.of(context).pop(); // Dismiss dialog
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Delete Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
