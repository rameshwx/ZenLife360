import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zenlife/database/dbhelper/prescription_helper.dart';
import 'prescription_page.dart';

enum OrderOptions { orderaz, orderza }

class PrescriptionList extends StatefulWidget {
  const PrescriptionList({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PrescriptionList> {
  prescriptionHelper helper = prescriptionHelper();
  List<prescription> contacts = [];
  List<prescription> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadContacts();
  }

  void _initDatabaseAndLoadContacts() async {
    await helper.initDb(); // Initialize the database
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        actions: <Widget>[
          if (!(ModalRoute.of(context)?.settings.name ==
              '/contact')) // Check if the current page is not the ContactPage
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearchBar();
              },
            ),
          if (!(ModalRoute.of(context)?.settings.name ==
              '/contact')) // Check if the current page is not the ContactPage
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  value: OrderOptions.orderaz,
                  child: Text('Sort from A-Z'),
                ),
                const PopupMenuItem<OrderOptions>(
                  value: OrderOptions.orderza,
                  child: Text('Sort from Z-A'),
                ),
              ],
              onSelected: _orderList,
            ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: filteredContacts.length,
        itemBuilder: _contactCard,
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showLargeImage(filteredContacts[index].img);
                },
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: filteredContacts[index].img != null
                          ? FileImage(File(filteredContacts[index].img!))
                          : const AssetImage('assets/images/Prescription.jpg')
                              as ImageProvider<Object>,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      filteredContacts[index].name ?? '',
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
      onLongPress: () {
        _showLongPressOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _showLargeImage(filteredContacts[index].img);
                  },
                  child: Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: filteredContacts[index].img != null
                              ? FileImage(File(filteredContacts[index].img!))
                              : const AssetImage(
                                      'assets/images/Prescription.jpg')
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Name: ${filteredContacts[index].name}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 5.0),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactPage({prescription? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ContactPage(helper: helper, contact: contact ?? prescription()),
      ),
    );

    if (recContact != null) {
      // If the returned contact is not null, update the contact list
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllprescription().then((list) {
      setState(() {
        contacts = list;
        _searchContacts(); // Refresh search results after updating contacts
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return (a.id ?? 0).compareTo(b.id ?? 0);
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return (b.id ?? 0).compareTo(a.id ?? 0);
        });
        break;
    }
    setState(() {
      _searchContacts(); // Refresh search results after sorting contacts
    });
  }

  void _deleteContact(int index) {
    if (filteredContacts[index].id != null) {
      helper.deleteprescription(filteredContacts[index].id!);
      setState(() {
        _getAllContacts(); // Refresh contact list after deletion
      });
    }
  }

  void _showSearchBar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search by name or number',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchContacts();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _searchContacts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        String name = contact.name?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  void _showLongPressOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showContactPage(contact: filteredContacts[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                  onPressed: () {
                    _deleteContact(index);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLargeImage(String? imagePath) {
    if (imagePath != null) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Image.file(File(imagePath)),
            ),
          );
        },
      );
    }
  }
}
