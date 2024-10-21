import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawprints/services/pet.service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawprints/ui/utils/pawprints_appbar.dart';
import 'package:pawprints/ui/utils/toast.dart';

import '../../models/pets/pets.dart';

class CreatePet extends StatefulWidget {
  const CreatePet({super.key});

  @override
  State<CreatePet> createState() => _CreatePetState();
}

class _CreatePetState extends State<CreatePet> {
  final PetService petService = PetService();
  final _formKey = GlobalKey<FormState>();

  // Fields to store user input
  String _name = '';
  String _species = '';
  String _breed = '';
  DateTime? _birthday;
  Map<String, String> _otherDetails = {};
  File? _imageFile; // Field to store the selected image

  // Function to create pet
  void _createPet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new pet instance
      Pet newPet = Pet(
        id: generateRandomNumber(), // Unique ID
        name: _name,
        species: _species,
        breed: _breed,
        birthday: _birthday!,
        otherDetails: _otherDetails,
        image: _imageFile != null
            ? _imageFile!.path
            : '', // Add image path if available
      );

      try {
        await petService.createPet(newPet, _imageFile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet created successfully!')),
        );
        Navigator.pop(context); // Optionally navigate back
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create pet: $e')),
        );
      }
    }
  }

  // Function to pick a date
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Function to show a bottom sheet for adding other details
  void _showOtherDetailsBottomSheet() {
    final TextEditingController detailKeyController = TextEditingController();
    final TextEditingController detailValueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: detailKeyController,
                decoration: const InputDecoration(labelText: 'Detail Key'),
              ),
              TextField(
                controller: detailValueController,
                decoration: const InputDecoration(labelText: 'Detail Value'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (detailKeyController.text.isNotEmpty &&
                      detailValueController.text.isNotEmpty) {
                    setState(() {
                      _otherDetails[detailKeyController.text] =
                          detailValueController.text;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Detail'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PawprintsAppbar(title: "Add Pet"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Pet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a species';
                  }
                  return null;
                },
                onSaved: (value) => _species = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
                onSaved: (value) => _breed = value!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _birthday == null
                        ? 'No date chosen!'
                        : 'Birthday: ${DateFormat('yyyy-MM-dd').format(_birthday!)}',
                  ),
                  TextButton(
                    onPressed: () => _selectBirthday(context),
                    child: const Text('Choose Birthday'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.file(
                    _imageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ElevatedButton(
                onPressed: _showOtherDetailsBottomSheet,
                child: const Text('Add Other Details'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _createPet,
                child: const Text('Create Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
