import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenlife/ui/meal_plan/food_categories_page.dart';
import 'package:zenlife/ui/prescriptions/prescription_list_page.dart';

import 'articles/article_page.dart';
import 'bmi/bmi_page.dart';
import 'journal/journal_list_page.dart';
import 'meal_plan/user_meal_entries_page.dart';
import 'medications/medication_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? ''; // Default to 'User' if name not found
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $userName'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Creates a grid with 2 columns
        children: <Widget>[
          _buildTile('Articles', Icons.article),
          _buildTile('Journal', Icons.book),
          _buildTile('Prescriptions', Icons.medical_services),
          _buildTile('Meal Plan', Icons.restaurant_menu),
          _buildTile('BMI', Icons.fitness_center),
          _buildTile('Medications', Icons.healing),
        ],
      ),
    );
  }

  Widget _buildTile(String title, IconData icon) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (title == 'Articles') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage()));
          }else if (title == 'BMI') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BMIPage()));
          }else if (title == 'Meal Plan') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodCategoriesPage()));
          }else if (title == 'Journal') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => JournalPage()));
          }else if (title == 'Prescriptions') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrescriptionList()));
          }else if (title == 'Medications') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MedicationHomePage()));
          } else {
            // Handle other tiles' onTap events here
            print('$title tapped!');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 80),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
