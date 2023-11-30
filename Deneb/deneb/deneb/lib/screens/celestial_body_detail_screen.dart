import 'dart:io';
import 'package:flutter/material.dart';
import '../class/celestial_body.dart';

class CelestialBodyDetailScreen extends StatelessWidget {
  final CelestialBody celestialBody;

  CelestialBodyDetailScreen({required this.celestialBody});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(celestialBody.name),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          SizedBox(height: 16),
          Text('Description: ${celestialBody.description}'),
          Text('Type: ${celestialBody.type}'),
          Text('Nature: ${celestialBody.majorityNature}'),
          Text('Size: ${celestialBody.sizeInKm} km'),
          Text(
              'Distance from Earth: ${celestialBody.distanceFromEarth} million km'),
          // Puedes agregar más detalles según sea necesario
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (celestialBody.imagePath.isNotEmpty) {
      File imageFile = File(celestialBody.imagePath);
      if (imageFile.existsSync()) {
        return Image.file(imageFile,
            height: 200, width: 200, fit: BoxFit.cover);
      } else {
        return Text('Image not found');
      }
    } else {
      return Text('No image path provided');
    }
  }
}
