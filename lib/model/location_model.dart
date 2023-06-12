const String tableLocation = 'Location';
const String locationId = '_id';
const String locationTitle = 'title';
const String timeVisitedLocation = 'timestamp';

const String tableNotification = 'Notification';
const String notificationId = '_id';
const String notificationTitle = 'title';
const String notificationDescRow = 'desc';

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

class UserNotification {
  int? id;
  String? title;
  String? notificationDesc;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      notificationTitle: title,
      notificationDescRow: notificationDesc
    };
    if (id != null) {
      map[notificationId] = id;
    }
    return map;
  }

  UserNotification(this.title, this.notificationDesc);

  UserNotification.fromMap(Map<String, dynamic> map) {
    id = map[notificationId];
    title = map[notificationTitle];
    notificationDesc = map[notificationDescRow];
  }
}
