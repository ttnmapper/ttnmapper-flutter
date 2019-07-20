import 'package:meta/meta.dart';

import 'location.dart';

///
/// A representation of a TTN gateway.
///
@immutable
class Gateway {
  final String id;
  final int rssi;
  final Location location;

  Gateway({
    this.id,
    this.rssi,
    this.location,
  });

  Gateway.fromJson(Map<String, dynamic> json)
      : id = json['gtw_id'],
        rssi = json['rssi'],
        location = Location(
          latitude: json['latitude'] != null? json['latitude'] : -100.0,
          longitude: json['longitude'] != null ? json['longitude'] : -200.0
        );
}
