import 'package:covid_tracker_app/model/database.dart';
import 'package:covid_tracker_app/model/location_model.dart';
import 'package:covid_tracker_app/model/resource.dart';
import 'package:flutter/material.dart';

class LocationViewModel extends ChangeNotifier {
  late LocationDatabaseProvider _locationProvider;

  LocationViewModel() {
    _locationProvider = LocationDatabaseProvider();
    _locationProvider.open("location3_db.db");
  }

  Future<Location> putLocation(Location location) async {
    return await _locationProvider.insertLocation(location);
  }

  Resource<List<Location>> getLocationsResource = Resource.idle();

  Future<void> getAllLocations() async {
    try {
      getLocationsResource = Resource.loading();
      notifyListeners();

      final list = await _locationProvider.getLocations();

      getLocationsResource = Resource.success(list);
      notifyListeners();
    } catch (e) {
      getLocationsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
