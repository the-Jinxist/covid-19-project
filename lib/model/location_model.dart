const String tableLocation = 'Location';
const String locationId = '_id';
const String locationTitle = 'title';
const String timeVisitedLocation = 'timestamp';

class Location {
  int? id;
  String? title;
  String? visitedLocationTile;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      locationTitle: title,
      timeVisitedLocation: visitedLocationTile
    };
    if (id != null) {
      map[locationId] = id;
    }
    return map;
  }

  Location(this.title, this.visitedLocationTile);

  Location.fromMap(Map<String, dynamic> map) {
    id = map[locationId];
    title = map[locationTitle];
    visitedLocationTile = map[timeVisitedLocation];
  }
}
