import 'package:flutter/material.dart';
import '../class/database_helper.dart';
import '../class/planetary_system.dart';

class AddSystemScreen extends StatefulWidget {
  @override
  _AddSystemScreenState createState() => _AddSystemScreenState();
}

class _AddSystemScreenState extends State<AddSystemScreen> {
  final TextEditingController _systemNameController = TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add System'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Name:'),
            TextField(
              controller: _systemNameController,
              decoration: InputDecoration(
                hintText: 'Enter system name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Validate and save the system to the database
                if (_systemNameController.text.isNotEmpty) {
                  await databaseHelper.insertSystem(
                    PlanetarySystem(name: _systemNameController.text),
                  );
                  Navigator.pop(context); // Go back to the previous screen
                } else {
                  // Show error message if necessary
                  // You can add additional validation logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a system name.'),
                    ),
                  );
                }
              },
              child: Text('Save System'),
            ),
          ],
        ),
      ),
    );
  }
}
