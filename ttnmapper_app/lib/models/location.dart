import 'package:meta/meta.dart';

///
/// A representation of a location on the map (in latitude and longitude).
///
@immutable
class Location {
  final double latitude;
  final double longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  bool isValid() {
    return latitude > -90.0 &&
        latitude < 90.0 &&
        longitude > -180.0 &&
        longitude < 180.0;
  }
}
