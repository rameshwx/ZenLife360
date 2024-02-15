import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      userName = prefs.getString('name') ?? 'User'; // Default to 'User' if name not found
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName'),
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
          // Implement navigation to respective pages
          print('$title tapped!');
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
