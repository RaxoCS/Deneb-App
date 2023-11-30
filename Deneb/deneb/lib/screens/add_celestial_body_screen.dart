import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../class/celestial_body.dart';
import '../class/database_helper.dart';
import '../class/planetary_system.dart';
import '../class/celestial_type.dart';
import '../class/nature_type.dart';

class AddCelestialBodyScreen extends StatefulWidget {
  final PlanetarySystem system;

  AddCelestialBodyScreen({required this.system});

  @override
  _AddCelestialBodyScreenState createState() => _AddCelestialBodyScreenState();
}

class _AddCelestialBodyScreenState extends State<AddCelestialBodyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sizeInKmController = TextEditingController();
  final TextEditingController _distanceFromEarthController =
      TextEditingController();

  IconData _selectedNatureIcon = Icons.cloud; // Icono por defecto
  IconData _selectedTypeIcon = Icons.star; // Icono por defecto
  File? _image; // Imagen seleccionada

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
            _buildTypeSelection(),
            SizedBox(height: 16.0),
            _buildNatureSelection(),
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

  Widget _buildTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTypeButton(Icons.apartment, CelestialType.system, 'System'),
        _buildTypeButton(Icons.star, CelestialType.star, 'Star'),
        _buildTypeButton(Icons.circle, CelestialType.planet, 'Planet'),
        _buildTypeButton(Icons.adjust, CelestialType.asteroid, 'Asteroid'),
        _buildTypeButton(
            Icons.help, CelestialType.unidentified, 'Unidentified'),
      ],
    );
  }

  Widget _buildTypeButton(
      IconData icon, CelestialType celestialType, String tooltip) {
    return Column(
      children: [
        Tooltip(
          message: tooltip,
          child: IconButton(
            icon: _selectedTypeIcon == icon
                ? Icon(icon,
                    color: Colors.blue) // Cambiar el color al seleccionado
                : Icon(icon),
            onPressed: () {
              setState(() {
                _selectedTypeIcon = icon;
              });
            },
          ),
        ),
        Text(tooltip),
      ],
    );
  }

  Widget _buildNatureSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNatureButton(Icons.cloud, NatureType.gas, 'Gas'),
        _buildNatureButton(Icons.invert_colors, NatureType.liquid, 'Liquid'),
        _buildNatureButton(Icons.cloud_circle, NatureType.solid, 'Solid'),
        _buildNatureButton(Icons.terrain, NatureType.rocky, 'Rocky'),
      ],
    );
  }

  Widget _buildNatureButton(
      IconData icon, NatureType natureType, String tooltip) {
    return Column(
      children: [
        Tooltip(
          message: tooltip,
          child: IconButton(
            icon: _selectedNatureIcon == icon
                ? Icon(icon,
                    color: Colors.blue) // Cambiar el color al seleccionado
                : Icon(icon),
            onPressed: () {
              setState(() {
                _selectedNatureIcon = icon;
              });
            },
          ),
        ),
        Text(tooltip),
      ],
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

  NatureType _getNatureType(IconData natureIcon) {
    if (natureIcon == Icons.cloud) {
      return NatureType.gas;
    } else if (natureIcon == Icons.invert_colors) {
      return NatureType.liquid;
    } else if (natureIcon == Icons.cloud_circle) {
      return NatureType.solid;
    } else if (natureIcon == Icons.terrain) {
      return NatureType.rocky;
    } else {
      return NatureType.gas;
    }
  }

  CelestialType _getCelestialType(IconData typeIcon) {
    if (typeIcon == Icons.apartment) {
      return CelestialType.system;
    } else if (typeIcon == Icons.star) {
      return CelestialType.star;
    } else if (typeIcon == Icons.circle) {
      return CelestialType.planet;
    } else if (typeIcon == Icons.adjust) {
      return CelestialType.asteroid;
    } else if (typeIcon == Icons.help) {
      return CelestialType.unidentified;
    } else {
      return CelestialType.unidentified;
    }
  }

  void _saveCelestialBody() async {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _sizeInKmController.text.isNotEmpty &&
        _distanceFromEarthController.text.isNotEmpty &&
        _image != null) {
      CelestialBody celestialBody = CelestialBody(
        name: _nameController.text,
        imagePath: _image!.path,
        description: _descriptionController.text,
        type: _getCelestialType(_selectedTypeIcon),
        majorityNature: _getNatureType(_selectedNatureIcon),
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
