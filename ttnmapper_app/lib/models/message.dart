import 'package:meta/meta.dart';

import 'gateway.dart';

///
/// A representation of an message received from the TTN MQTT broker.
///
@immutable
class Message {
  final String deviceId;
  final Metadata metadata;

  Message({
    this.deviceId,
    this.metadata,
  });

  Message.fromJson(Map<String, dynamic> json)
      : deviceId = json['dev_id'],
        metadata = Metadata.fromJson(json['metadata']);
}

class Metadata {
  final String time;
  final double frequency;
  final String modulation;
  final String data_rate;
  final String coding_rate;
  final List<Gateway> gateways;

  //IDEA: Use mapper as a display for GPS nodes
  final double latitude;
  final double longitude;

  Metadata({
    this.time,
    this.frequency,
    this.modulation,
    this.data_rate,
    this.coding_rate,
    this.latitude,
    this.longitude,
    this.gateways,
  });

  Metadata.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        frequency = json['frequency'],
        modulation = json['modulation'],
        data_rate = json['data_rate'],
        coding_rate = json['coding_rate'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        gateways = json['gateways'] != null
            ? json['gateways'].map<Gateway>((i) => Gateway.fromJson(i)).toList()
            : [];
}
