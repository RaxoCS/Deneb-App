class PlanetarySystem {
  int? id;
  String name;

  PlanetarySystem({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
