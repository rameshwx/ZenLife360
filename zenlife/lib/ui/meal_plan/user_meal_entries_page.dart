import 'package:flutter/material.dart';
import 'package:zenlife/ui/meal_plan/snack_page.dart';

import 'breakfast_page.dart';
import 'dinner_page.dart';
import 'lunch_page.dart';

class UserMealEntriesPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final Function(int, bool) toggleSelection;
  final List<Map<String, dynamic>> foodCategories;
  final List<bool> isSelected;
  final String selectedCategory;

  const UserMealEntriesPage(param0, {
    Key? key,
    required this.selectedItems,
    required this.toggleSelection,
    required this.foodCategories,
    required this.isSelected,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  _UserMealEntriesPageState createState() => _UserMealEntriesPageState();
}

class _UserMealEntriesPageState extends State<UserMealEntriesPage> {
  List<Map<String, dynamic>> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.selectedItems);
  }

  void _removeItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
      widget.toggleSelection(index, false);
    });
  }

  Widget _buildBottomNavBarItem(
    IconData icon, String label, Function() onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onTap,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.selectedCategory} for my meals',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueAccent),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) {
              return const [
                'Food Categories',
                'Selected Items',
                'Journal',
                'Journal List'
              ].map((page) {
                return PopupMenuItem(
                  value: page,
                  child: Text(page),
                );
              }).toList();
            },
            onSelected: (String page) {
              Navigator.pop(context);
              // Navigate based on selected page
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: _selectedItems.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> item = _selectedItems[index];
            final int id = item['id'];
            return Card(
              elevation: 4,
              key: ValueKey<int>(id),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['name']} ID: $id',
                            style: const TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 1, 109, 95)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Calories per 100g: ${item['calories_per_100g']} kcal',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
                          ),
                          Text(
                            'Calories per Cup: ${item['calories_per_cup']} kcal',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        _removeItem(index);
                      },
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 254, 254),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildBottomNavBarItem(Icons.breakfast_dining, 'Breakfast', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BreakfastPage(selectedItems: [],)),
              );
            }),
            _buildBottomNavBarItem(Icons.lunch_dining, 'Lunch', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LunchPage(selectedItems: [],)),
              );
            }),
            _buildBottomNavBarItem(Icons.local_dining, 'Dinner', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DinnerPage(selectedItems: [],)),
              );
            }),
            _buildBottomNavBarItem(Icons.local_pizza, 'Snack', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SnackPage(selectedItems: [],)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
