class CelestialBody {
  int? id;
  String name;
  String imagePath;
  String description;
  String type;
  String majorityNature;
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
      'type': type,
      'majorityNature': majorityNature,
      'sizeInKm': sizeInKm,
      'distanceFromEarth': distanceFromEarth,
      'systemId': systemId,
    };
  }
}
