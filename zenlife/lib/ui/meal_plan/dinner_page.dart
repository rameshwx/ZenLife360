import 'package:flutter/material.dart';

class DinnerPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  const DinnerPage({Key? key, required this.selectedItems}) : super(key: key);

  @override
  _DinnerPageState createState() => _DinnerPageState();
}

class _DinnerPageState extends State<DinnerPage> {
  // Method to remove an item from the selectedItems list
  void _removeItem(int index) {
    setState(() {
      widget.selectedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dinner Page',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Items for Dinner:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> item = widget.selectedItems[index];
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
                                  style: TextStyle(fontWeight: FontWeight.w900, color: const Color.fromARGB(255, 1, 109, 95)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Calories per 100g: ${item['calories_per_100g']} kcal',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
                                ),
                                Text(
                                  'Calories per Cup: ${item['calories_per_cup']} kcal',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
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
          ],
        ),
      ),
    );
  }
}
