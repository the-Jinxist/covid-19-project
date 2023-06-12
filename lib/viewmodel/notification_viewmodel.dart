import 'package:covid_tracker_app/model/database.dart';
import 'package:covid_tracker_app/model/location_model.dart';
import 'package:covid_tracker_app/model/resource.dart';
import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  late LocationDatabaseProvider _locationProvider;

  NotificationViewModel() {
    _locationProvider = LocationDatabaseProvider();
    _locationProvider.open("location3_db.db");
  }

  Future<UserNotification> putLocation(UserNotification notification) async {
    return await _locationProvider.insertNotification(notification);
  }

  Resource<List<UserNotification>> getNotificationsResource = Resource.idle();

  Future<void> getAllNotifications() async {
    try {
      getNotificationsResource = Resource.loading();
      notifyListeners();

      final list = await _locationProvider.getNotifications();

      getNotificationsResource = Resource.success(list);
      notifyListeners();
    } catch (e) {
      getNotificationsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
