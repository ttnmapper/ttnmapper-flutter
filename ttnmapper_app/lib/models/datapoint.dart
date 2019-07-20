import 'package:meta/meta.dart';

import 'gateway.dart';
import 'location.dart';

///
/// A datapoint which can be displayed on the map.
///
@immutable
class DataPoint {
  final String deviceId;
  final int rssi;

  final Location location;
  final Gateway gateway;

  DataPoint({
    this.deviceId,
    this.rssi,
    this.location,
    this.gateway,
  });
}
