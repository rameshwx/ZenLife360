import 'package:flutter/material.dart';
import 'package:zenlife/ui/meal_plan/snack_page.dart';
import 'package:zenlife/ui/meal_plan/user_meal_entries_page.dart';

import '../../controller/category_types_controller.dart';
import 'breakfast_page.dart';
import 'dinner_page.dart';
import 'lunch_page.dart';

class FoodCategoriesPage extends StatefulWidget {
  @override
  _FoodCategoriesPageState createState() => _FoodCategoriesPageState();
}

class _FoodCategoriesPageState extends State<FoodCategoriesPage> {
  final List<Map<String, dynamic>> foodCategories = [
    {"id": 001, "name": "Fruits", "calories_per_100g": 60, "calories_per_cup": 80, "image": "assets/fruits.jpg"},
    {"id": 002, "name": "Vegetables", "calories_per_100g": 25, "calories_per_cup": 35, "image": "assets/vegetables.jpg"},
    {"id": 003, "name": "Leafy Greens", "calories_per_100g": 10, "calories_per_cup": 15, "image": "assets/leafygreens.jpg"},
    {"id": 004, "name": "Grains", "calories_per_100g": 350, "calories_per_cup": 280, "image": "assets/grains.jpg"},
    {"id": 005, "name": "Nuts and Seeds", "calories_per_100g": 550, "calories_per_cup": 440, "image": "assets/nutsandseeds.jpg"},
    {"id": 006, "name": "Plant-based milks", "calories_per_100g": 40, "calories_per_serving": 80, "image": "assets/plantbasedmilks.jpg"},
    {"id": 007, "name": "Tofu", "calories_per_100g": 80, "calories_per_cup": 160, "image": "assets/tofu.jpg"},
    {"id": 008, "name": "Tempeh", "calories_per_100g": 200, "calories_per_cup": 320, "image": "assets/tempeh.jpg"},
    {"id": 009, "name": "Nutritional yeast", "calories_per_100g": 200, "calories_per_cup": 320, "image": "assets/nutritionalyeast.jpg"},
    {"id": 010, "name": "Red Meat", "calories_per_100g": 270, "calories_per_cup": 215, "image": "assets/redmeat.jpg"},
    {"id": 011, "name": "White Meat", "calories_per_100g": 170, "calories_per_cup": 135, "image": "assets/whitemeat.jpg"},
    {"id": 012, "name": "Poultry", "calories_per_100g": 170, "calories_per_cup": 135, "image": "assets/poultry.jpg"},
    {"id": 013, "name": "Seafood", "calories_per_100g": 150, "calories_per_cup": 120, "image": "assets/seafood.jpg"},
    {"id": 014, "name": "Eggs", "calories_per_100g": 75, "calories_per_cup": 150, "image": "assets/eggs.jpg"},
    {"id": 015, "name": "Milk", "calories_per_100g": 50, "calories_per_cup": 120, "image": "assets/milk.jpg"},
    {"id": 016, "name": "Cheese", "calories_per_100g": 350, "calories_per_cup": 280, "image": "assets/cheese.jpg"},
    {"id": 017, "name": "Yogurt", "calories_per_100g": 75, "calories_per_cup": 150, "image": "assets/yogurt.jpg"},
    {"id": 018, "name": "Butter", "calories_per_100g": 750, "calories_per_cup": 600, "image": "assets/butter.jpg"},
    {"id": 019, "name": "Snacks", "calories_per_100g": 450, "calories_per_cup": 360, "image": "assets/snacks.jpg"},
    {"id": 020, "name": "Sugary drinks", "calories_per_100g": 40, "calories_per_serving": 80, "image": "assets/sugarydrinks.jpg"},
    {"id": 021, "name": "Breakfast cereals", "calories_per_100g": 450, "calories_per_cup": 360, "image": "assets/breakfastcereals.jpg"},
    {"id": 022, "name": "Processed meats", "calories_per_100g": 350, "calories_per_cup": 280, "image": "assets/processedmeats.jpg"},
    {"id": 023, "name": "Ready made dishes", "calories_per_100g": 375, "calories_per_cup": 300, "image": "assets/readymadedishes.jpg"},
    {"id": 024, "name": "Condiments and spreads", "calories_per_100g": 100, "calories_per_cup": 100, "image": "assets/condimentsandspreads.jpg"},
  ];

  final List<String> pages = ['Food Categories', 'Selected Items'];

  String currentPage = 'Food Categories';
  List<bool> isSelected = List.generate(25, (index) => false);

  void changePage(String page) {
    if (currentPage != page) {
      setState(() {
        currentPage = page;
      });
    }
  }

  void toggleSelection(int index, bool selected) {
    setState(() {
      isSelected[index] = selected;
    });
  }

  int countSelectedItems() => isSelected.where((element) => element).length;

  void saveSelectedItems(CategoryType categoryType) {
    print('Category Type: $categoryType');
    final selectedItems = <Map<String, dynamic>>[];

    for (int i = 0; i < foodCategories.length; i++) {
      if (isSelected[i]) {
        selectedItems.add(foodCategories[i]);
      }
    }
    print('Selected Items for $categoryType: $selectedItems');

    final selectedPage = currentPage;
    if (categoryType == CategoryType.Breakfast) {
      print('Navigating to BreakfastPage');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BreakfastPage(selectedItems: selectedItems)),
      );
    } else if (categoryType == CategoryType.Lunch) {
      print('Navigating to LunchPage');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LunchPage(selectedItems: selectedItems)),
      );
    } else if (categoryType == CategoryType.Snack) {
      print('Navigating to SnackPage');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SnackPage(selectedItems: selectedItems)),
      );
    } else if (categoryType == CategoryType.Dinner) {
      print('Navigating to DinnerPage');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DinnerPage(selectedItems: selectedItems)),
      );
    }
  }

  List<Map<String, dynamic>> getSelectedItems() {
    final selectedItems = <Map<String, dynamic>>[];
    for (int i = 0; i < foodCategories.length; i++) {
      if (isSelected[i]) {
        selectedItems.add(foodCategories[i]);
      }
    }
    return selectedItems;
  }

  Widget buildCategoryTile(String title, CategoryType categoryType) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Center(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        onTap: () => saveSelectedItems(categoryType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Food Categories',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.blueAccent),
            ),
            SizedBox(width: 10), 
            if (countSelectedItems() > 0) 
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 10,
                child: Text(
                  countSelectedItems().toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) {
              return pages.map((page) {
                return PopupMenuItem(
                  value: page,
                  child: Text(page),
                );
              }).toList();
            },
            onSelected: (String page) {
              if (page == currentPage) {
                return;
              }
              changePage(page);
              if (page == 'Food Categories') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodCategoriesPage()),
                );
              } else if (page == 'Selected Items') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMealEntriesPage(0,
                      selectedItems: getSelectedItems(),
                      toggleSelection: toggleSelection,
                      foodCategories: foodCategories,
                      isSelected: isSelected,
                      selectedCategory: currentPage,
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: () {
              final allSelected = isSelected.every((element) => element);
              setState(() {
                isSelected = List.generate(25, (index) => !allSelected);
              });
            },
          ),
          if (countSelectedItems() > 0) 
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          'Category Type',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildCategoryTile('Breakfast', CategoryType.Breakfast),
                            buildCategoryTile('Lunch', CategoryType.Lunch),
                            buildCategoryTile('Snack', CategoryType.Snack),
                            buildCategoryTile('Dinner', CategoryType.Dinner),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: foodCategories.length,
          itemBuilder: (BuildContext context, int index) {
            final item = foodCategories[index];
            final id = item['id'];
            return GestureDetector(
              onTap: () {
                saveSelectedItems(CategoryType.values[index]);
              },
              child: Card(
                key: ValueKey<int>(id), 
                elevation: isSelected[index] ? 4 : 0, 
                color: isSelected[index] ? const Color.fromARGB(255, 250, 249, 249) : Colors.white,
                child: InkWell(
                  onTap: () => toggleSelection(index, !isSelected[index]),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            foodCategories[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['name']} ID: $id',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 109, 95)),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Calories per 100g: ${foodCategories[index]['calories_per_100g']} kcal',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
                              ),
                              Text(
                                'Calories per Cup: ${foodCategories[index]['calories_per_cup']} kcal',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: isSelected[index] ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.add_circle_outline),
                        onPressed: () => toggleSelection(index, !isSelected[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
