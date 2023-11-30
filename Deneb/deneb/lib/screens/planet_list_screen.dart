import 'dart:io';
import 'package:flutter/material.dart';
import '../class/planetary_system.dart';
import '../class/celestial_body.dart';
import '../screens/celestial_body_detail_screen.dart';
import '../screens/add_celestial_body_screen.dart';
import '../class/database_helper.dart';

class PlanetListScreen extends StatefulWidget {
  final PlanetarySystem system;

  PlanetListScreen({required this.system});

  @override
  _PlanetListScreenState createState() => _PlanetListScreenState();
}

class _PlanetListScreenState extends State<PlanetListScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<CelestialBody> _celestialBodies = [];
  List<CelestialBody> _filteredCelestialBodies = [];

  @override
  void initState() {
    super.initState();
    _loadCelestialBodies();
  }

  Future<void> _loadCelestialBodies() async {
    final celestialBodies =
        await databaseHelper.getCelestialBodiesBySystemId(widget.system.id!);
    setState(() {
      _celestialBodies = celestialBodies;
      _filteredCelestialBodies = celestialBodies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.system.name} - Celestial Bodies',
          style: TextStyle(
              fontSize: 18), // Puedes ajustar el tamaño según tus preferencias
        ),
        automaticallyImplyLeading:
            false, // Esta línea evita que aparezca la flecha de retroceso
        actions: [
          IconButton(
            onPressed: () {
              _handleSearch(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _buildCelestialBodyList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddCelestialBodyScreen(system: widget.system),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCelestialBodyList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _celestialBodies.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            final deletedCelestialBody = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CelestialBodyDetailScreen(
                  celestialBody: _celestialBodies[index],
                ),
              ),
            );

            // Si se eliminó un cuerpo celeste, actualizamos el estado
            if (deletedCelestialBody != null) {
              setState(() {
                _celestialBodies.remove(deletedCelestialBody);
                _filteredCelestialBodies.remove(deletedCelestialBody);
              });
            }
          },
          child: Card(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mostrar la imagen asociada al celestial body
                Image.file(
                  File(_celestialBodies[index].imagePath),
                  width: 310, // Ajusta según sea necesario
                  height: 680,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _celestialBodies[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: CelestialBodySearchDelegate(_celestialBodies),
    );
  }
}

class CelestialBodySearchDelegate extends SearchDelegate<CelestialBody?> {
  final List<CelestialBody> celestialBodies;

  CelestialBodySearchDelegate(this.celestialBodies) : super();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filteredCelestialBodies = celestialBodies
        .where((celestialBody) => celestialBody.majorityNature
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildCelestialBodyList(context, filteredCelestialBodies);
  }

  Widget _buildCelestialBodyList(
    BuildContext context,
    List<CelestialBody> celestialBodies,
  ) {
    return ListView.builder(
      itemCount: celestialBodies.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(celestialBodies[index].name),
          onTap: () {
            close(context, celestialBodies[index]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CelestialBodyDetailScreen(
                  celestialBody: celestialBodies[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
