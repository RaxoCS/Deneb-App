import 'dart:io';
import 'package:flutter/material.dart';
import '../class/celestial_body.dart';
import '../class/database_helper.dart';

class CelestialBodyDetailScreen extends StatelessWidget {
  final CelestialBody celestialBody;

  CelestialBodyDetailScreen({required this.celestialBody});

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          celestialBody.name,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          _buildPopupMenuButton(context),
        ],
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildInfoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              celestialBody.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description: ${celestialBody.description}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Type', celestialBody.type),
            _buildInfoRow('Nature', celestialBody.majorityNature),
            _buildInfoRow('Size', '${celestialBody.sizeInKm} km'),
            _buildInfoRow(
              'Distance from Earth',
              '${celestialBody.distanceFromEarth} million km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    if (celestialBody.imagePath.isNotEmpty) {
      File imageFile = File(celestialBody.imagePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }
    return Container(); // Placeholder si no hay imagen
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _handleDelete(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    );
  }

  void _handleDelete(BuildContext context) async {
    await databaseHelper.deleteCelestialBody(celestialBody.id!);
    Navigator.pop(context, celestialBody);
  }
}
