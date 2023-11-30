import 'celestial_type.dart';
import 'nature_type.dart';

class CelestialBody {
  int? id;
  String name;
  String imagePath;
  String description;
  CelestialType type; // Usa el tipo enumerado CelestialType
  NatureType majorityNature; // Usa el tipo enumerado NatureType
  double sizeInKm;
  double distanceFromEarth;
  int? systemId;

  CelestialBody({
    this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.type,
    required this.majorityNature,
    required this.sizeInKm,
    required this.distanceFromEarth,
    this.systemId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'description': description,
      'type': type.index, // Almacena el índice del tipo enumerado
      'majorityNature':
          majorityNature.index, // Almacena el índice de la naturaleza enumerada
      'sizeInKm': sizeInKm,
      'distanceFromEarth': distanceFromEarth,
      'systemId': systemId,
    };
  }

  // Método estático para convertir de cadena a CelestialType
  static CelestialType stringToCelestialType(String type) {
    switch (type) {
      case 'System':
        return CelestialType.system;
      case 'Star':
        return CelestialType.star;
      case 'Planet':
        return CelestialType.planet;
      case 'Asteroid':
        return CelestialType.asteroid;
      case 'Unidentified':
        return CelestialType.unidentified;
      default:
        return CelestialType.unidentified;
    }
  }

  // Método estático para convertir de cadena a NatureType
  static NatureType stringToNatureType(String nature) {
    switch (nature) {
      case 'Gas':
        return NatureType.gas;
      case 'Liquid':
        return NatureType.liquid;
      case 'Solid':
        return NatureType.solid;
      case 'Rocky':
        return NatureType.rocky;
      default:
        return NatureType.solid;
    }
  }

  static String celestialTypeToString(CelestialType type) {
    switch (type) {
      case CelestialType.system:
        return 'System';
      case CelestialType.star:
        return 'Star';
      case CelestialType.planet:
        return 'Planet';
      case CelestialType.asteroid:
        return 'Asteroid';
      case CelestialType.unidentified:
        return 'Unidentified';
      default:
        return '';
    }
  }

  static String natureTypeToString(NatureType nature) {
    switch (nature) {
      case NatureType.gas:
        return 'Gas';
      case NatureType.liquid:
        return 'Liquid';
      case NatureType.solid:
        return 'Solid';
      case NatureType.rocky:
        return 'Rocky';
      default:
        return '';
    }
  }
}
