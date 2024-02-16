// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenlife/database/dbhelper/prescription_helper.dart';

class ContactPage extends StatefulWidget {
  final prescription? contact;
  final prescriptionHelper helper;

  const ContactPage({Key? key, required this.helper, this.contact})
      : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _descriptionController =
      TextEditingController(); // Controller for description
  final _nameFocus = FocusNode();
  bool _userEdited = false;
  late prescription _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = prescription();
    } else {
      _editedContact = prescription.fromMap(widget.contact!.toMap());
    }

    _nameController.text = _editedContact.name ?? '';
    _descriptionController.text =
        _editedContact.description ?? ''; // Set description text
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? 'Add Prescription'),
          backgroundColor: Colors.blue[200],
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _saveprescriptionct();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null &&
                _editedContact.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.blue[200],
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img!))
                              : AssetImage('assets/images/Prescription.jpg')
                                  as ImageProvider<
                                      Object>, // <-- Cast AssetImage to ImageProvider<Object>
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      bottom: 0,
                      child: Container(
                        width: 155,
                        child: const Text(
                          'Add Prescription Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile == null) return;
                  setState(() {
                    _editedContact.img = pickedFile.path;
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(labelText: 'Heading'),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller:
                    _descriptionController, // Controller for description
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.description = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('If you exit, the changes will be lost.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _saveprescriptionct() {
    // Update _editedContact with the values from the controllers
    _editedContact.name = _nameController.text;
    _editedContact.description =
        _descriptionController.text; // Update description

    if (_editedContact.id != null) {
      // If the contact already exists, update it
      widget.helper.updateprescription(_editedContact);
    } else {
      // If it's a new contact, save it
      widget.helper.saveprescription(_editedContact);
    }

    // Return the updated/created contact
    Navigator.pop(context, _editedContact);
  }
}
