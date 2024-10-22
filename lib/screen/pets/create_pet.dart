import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawprints/services/pet.service.dart';
import 'package:pawprints/ui/utils/pawprints_appbar.dart';
import 'package:pawprints/models/pets/pets.dart';
import 'package:pawprints/ui/utils/toast.dart';

class CreatePet extends StatefulWidget {
  const CreatePet({super.key});

  @override
  State<CreatePet> createState() => _CreatePetState();
}

class _CreatePetState extends State<CreatePet> {
  final PetService petService = PetService();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _species = '';
  String _breed = '';
  DateTime? _birthday;
  Map<String, String> _otherDetails = {};
  File? _imageFile;

  void _createPet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Pet newPet = Pet(
        id: generateRandomNumber(),
        name: _name,
        species: _species,
        breed: _breed,
        birthday: _birthday!,
        otherDetails: _otherDetails,
        image: _imageFile != null ? _imageFile!.path : '',
      );

      try {
        await petService.createPet(newPet, _imageFile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet created successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create pet: $e')),
        );
      }
    }
  }

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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'lib/assets/img/pawprint_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image.asset(
                        'lib/assets/img/paw_logo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      prefixIcon: const Icon(Icons.pets, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Species',
                      prefixIcon: const Icon(Icons.pets, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a species';
                      }
                      return null;
                    },
                    onSaved: (value) => _species = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Breed',
                      prefixIcon: const Icon(Icons.pets, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a breed';
                      }
                      return null;
                    },
                    onSaved: (value) => _breed = value!,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _birthday == null
                            ? 'No date chosen!'
                            : 'Birthday: ${DateFormat('yyyy-MM-dd').format(_birthday!)}',
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _selectBirthday(context),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Choose Birthday'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageFile == null
                          ? Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Image.file(
                              _imageFile!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showOtherDetailsBottomSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Other Details'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _createPet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Create Pet',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
