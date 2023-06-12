import 'package:covid_tracker_app/model/location_model.dart';

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

class LocationsFromPushNotification {
  final List<Location>? locations;

  LocationsFromPushNotification({this.locations});

  factory LocationsFromPushNotification.fromJson(Map<String, dynamic> json) {
    return LocationsFromPushNotification(
        locations: (json['locations'] as List<dynamic>?)
            ?.map((e) => Location.fromMap(e as Map<String, dynamic>))
            .toList());
  }
}
