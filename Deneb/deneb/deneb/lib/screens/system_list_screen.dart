import 'package:flutter/material.dart';
import '../class/database_helper.dart';
import '../class/planetary_system.dart';
import 'planet_list_screen.dart';
import 'add_system_screen.dart';

class SystemListScreen extends StatefulWidget {
  @override
  _SystemListScreenState createState() => _SystemListScreenState();
}

class _SystemListScreenState extends State<SystemListScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deneb - Systems'),
      ),
      body: FutureBuilder<List<PlanetarySystem>>(
        future: databaseHelper.getAllSystems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No systems found.');
          } else {
            return _buildSystemList(context, snapshot.data!);
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSystemScreen(),
                ),
              ).then((value) {
                // Refresh the list after adding a system
                setState(() {});
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemList(BuildContext context, List<PlanetarySystem> systems) {
    return ListView.builder(
      itemCount: systems.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(systems[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlanetListScreen(system: systems[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
