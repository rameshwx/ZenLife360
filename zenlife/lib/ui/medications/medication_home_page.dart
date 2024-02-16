import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../database/models/medicine.dart';
import 'medicine_details/medicine_details.dart';
import 'new_entry/new_entry_page.dart';
import 'common/constants.dart';

class MedicationHomePage extends StatelessWidget {
  const MedicationHomePage({Key? key}) : super(key: key);

  static List<Medicine> medicines = [
    Medicine(medicineName: "Aspirin", medicineType: "Pill", interval: 8),
    Medicine(medicineName: "Ibuprofen", medicineType: "Tablet", interval: 6),
    // Add more medicines as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Tracker'),
      ),
      body: Column(
        children: [
          TopContainer(),
          Expanded(
            child: BottomContainer(medicines: medicines),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEntryPage()),
          );
        },
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Worry less.\nLive healthier.',
            style: Theme.of(context).textTheme.headline5?.copyWith(color: kPrimaryColor),
          ),
          SizedBox(height: 8),
          Text(
            'Welcome to Daily Dose.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          Text(
            '${MedicationHomePage.medicines.length} Medicines',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final List<Medicine> medicines;
  const BottomContainer({Key? key, required this.medicines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return Center(child: Text('No Medicine'));
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return MedicineCard(medicine: medicine);
        },
      );
    }
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicineDetails(medicine: medicine)),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/${medicine.medicineType?.toLowerCase()}.svg',
              color: kOtherColor,
              width: 48, // Adjust the size as needed
            ),
            SizedBox(height: 8),
            Text(
              medicine.medicineName!,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Text(
              "Every ${medicine.interval} hours",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
