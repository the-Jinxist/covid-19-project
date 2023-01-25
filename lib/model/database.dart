import 'package:covid_tracker_app/model/location_model.dart';
import 'package:sqflite/sqflite.dart';

class LocationDatabaseProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableLocation ( 
  $locationId integer primary key autoincrement, 
  $locationTitle text not null,
  $timeVisitedLocation text not null)
''');
    });
  }

  Future<Location> insert(Location location) async {
    location.id = await db.insert(tableLocation, location.toMap());
    return location;
  }

  Future<Location?> getLocation(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableLocation,
        columns: [locationId, timeVisitedLocation, locationTitle],
        where: '$locationId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Location.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Location>> getLocations() async {
    final List<Map<String, dynamic>> maps = await db.query('Location');

    return List.generate(maps.length, (i) {
      return Location.fromMap(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableLocation, where: '$locationId = ?', whereArgs: [id]);
  }

  Future<int> update(Location location) async {
    return await db.update(tableLocation, location.toMap(),
        where: '$locationId = ?', whereArgs: [location.id]);
  }

  Future close() async => db.close();
}
