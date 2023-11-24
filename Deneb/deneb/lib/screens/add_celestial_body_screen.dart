import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../class/celestial_body.dart';
import '../class/database_helper.dart';
import '../class/planetary_system.dart';

class AddCelestialBodyScreen extends StatefulWidget {
  final PlanetarySystem system;

  AddCelestialBodyScreen({required this.system});

  @override
  _AddCelestialBodyScreenState createState() => _AddCelestialBodyScreenState();
}

class _AddCelestialBodyScreenState extends State<AddCelestialBodyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _majorityNatureController =
      TextEditingController();
  final TextEditingController _sizeInKmController = TextEditingController();
  final TextEditingController _distanceFromEarthController =
      TextEditingController();

  File? _image; // Variable para almacenar la imagen seleccionada

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Celestial Body'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:'),
            TextField(controller: _nameController),
            SizedBox(height: 16.0),
            Text('Description:'),
            TextField(controller: _descriptionController),
            SizedBox(height: 16.0),
            Text('Type:'),
            TextField(controller: _typeController),
            SizedBox(height: 16.0),
            Text('Majority Nature:'),
            TextField(controller: _majorityNatureController),
            SizedBox(height: 16.0),
            Text('Size in Km:'),
            TextField(controller: _sizeInKmController),
            SizedBox(height: 16.0),
            Text('Distance from Earth:'),
            TextField(controller: _distanceFromEarthController),
            SizedBox(height: 16.0),
            _image == null
                ? ElevatedButton(
                    onPressed: () {
                      _getImageFromCamera();
                    },
                    child: Text('Select Image from Camera'),
                  )
                : Image.file(_image!, height: 100.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveCelestialBody();
              },
              child: Text('Save Celestial Body'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _saveCelestialBody() async {
    // Validar campos antes de guardar
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _majorityNatureController.text.isNotEmpty &&
        _sizeInKmController.text.isNotEmpty &&
        _distanceFromEarthController.text.isNotEmpty &&
        _image != null) {
      CelestialBody celestialBody = CelestialBody(
        name: _nameController.text,
        imagePath: _image!.path, // Usar la ruta de la imagen seleccionada
        description: _descriptionController.text,
        type: _typeController.text,
        majorityNature: _majorityNatureController.text,
        sizeInKm: double.parse(_sizeInKmController.text),
        distanceFromEarth: double.parse(_distanceFromEarthController.text),
        systemId: widget.system.id,
      );

      await databaseHelper.insertCelestialBody(celestialBody);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields and select an image.'),
        ),
      );
    }
  }
}
