import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'planetary_system.dart';
import '../class/celestial_body.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'deneb_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Código para crear tablas si la base de datos no existe
        await db.execute('''
          CREATE TABLE systems(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE celestial_bodies(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            imagePath TEXT,
            description TEXT,
            type TEXT,
            majorityNature TEXT,
            sizeInKm REAL,
            distanceFromEarth REAL,
            systemId INTEGER,
            FOREIGN KEY (systemId) REFERENCES systems(id)
          )
        ''');
      },
    );
  }

  Future<void> insertSystem(PlanetarySystem system) async {
    final Database db = await database;
    await db.insert('systems', system.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PlanetarySystem>> getAllSystems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('systems');
    return List.generate(maps.length, (index) {
      return PlanetarySystem(
        id: maps[index]['id'],
        name: maps[index]['name'],
      );
    });
  }

  Future<void> insertCelestialBody(CelestialBody celestialBody) async {
    final Database db = await database;
    await db.insert('celestial_bodies', celestialBody.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CelestialBody>> getCelestialBodiesBySystemId(int systemId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'celestial_bodies',
      where: 'systemId = ?',
      whereArgs: [systemId],
    );

    return List.generate(maps.length, (index) {
      return CelestialBody(
        id: maps[index]['id'],
        name: maps[index]['name'],
        imagePath: maps[index]['imagePath'],
        description: maps[index]['description'],
        type: maps[index]['type'],
        majorityNature: maps[index]['majorityNature'],
        sizeInKm: maps[index]['sizeInKm'],
        distanceFromEarth: maps[index]['distanceFromEarth'],
        systemId: maps[index]['systemId'],
      );
    });
  }

  Future<int> deleteCelestialBody(int id) async {
    final db = await database;
    return await db
        .delete('celestial_bodies', where: 'id = ?', whereArgs: [id]);
  }
}
