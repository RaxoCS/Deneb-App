import 'package:flutter/material.dart';
import '../class/planetary_system.dart';
import '../class/celestial_body.dart';
import '../screens/celestial_body_detail_screen.dart';
import '../screens/add_celestial_body_screen.dart';
import '../class/database_helper.dart';

class PlanetListScreen extends StatelessWidget {
  final PlanetarySystem system;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  PlanetListScreen({required this.system});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${system.name} - Planets'),
      ),
      body: FutureBuilder<List<CelestialBody>>(
        future: databaseHelper.getCelestialBodiesBySystemId(system.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No celestial bodies found for this system.');
          } else {
            return _buildCelestialBodyList(context, snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCelestialBodyScreen(system: system),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCelestialBodyList(
      BuildContext context, List<CelestialBody> celestialBodies) {
    return ListView.builder(
      itemCount: celestialBodies.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(celestialBodies[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CelestialBodyDetailScreen(
                      celestialBody: celestialBodies[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
