import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:ttnmapper_app/models/datapoint.dart';
import 'package:ttnmapper_app/models/location.dart';
import 'package:ttnmapper_app/models/message.dart';
import 'package:ttnmapper_app/util/color_util.dart';
import 'package:ttnmapper_app/widgets/session_control.dart';

import '../constants.dart';


class MapScreen extends StatefulWidget {
  final Position initialPosition;

  MapScreen(this.initialPosition);

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  StreamSubscription<Position> _positionStreamSubscription;
  MapboxMapController controller;
  Position _position;

  void onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.addListener(_onMapChanged);
  }

  void _onMapChanged() async {
    print('map changed');
  }

  void _onMessageReceived(message) {
    Message msg = new Message.fromJson(jsonDecode(message));
    for (var gateway in msg.metadata.gateways) {
      var datapoint = DataPoint(
          deviceId: msg.deviceId,
          rssi: gateway.rssi,
          gateway: gateway,
          location: Location(
              latitude: _position.latitude, longitude: _position.longitude));

      _addCircle(datapoint);

      if (gateway.location.isValid()) {
        _addLine(datapoint);
        _addSymbol(gateway);
      }
    }
  }

  void _addLine(datapoint) {
    var color = ColorUtil.parseColorForRssi(datapoint.rssi);
    var line = controller.addLine(
      LineOptions(
        geometry: [
          LatLng(datapoint.location.latitude, datapoint.location.longitude),
          LatLng(datapoint.gateway.location.latitude,
              datapoint.gateway.location.longitude),
        ],
        lineColor: color,
        lineWidth: 3.0,
        lineOpacity: 0.8,
      ),
    );
    print('line: $line');
  }

  void _addCircle(datapoint) {
    var color = ColorUtil.parseColorForRssi(datapoint.rssi);
    var circle = controller.addCircle(
      CircleOptions(
          geometry: LatLng(
            datapoint.location.latitude,
            datapoint.location.longitude,
          ),
          circleRadius: 8,
          circleOpacity: 0.95,
          circleStrokeWidth: 2,
          circleStrokeColor: color,
          circleColor: color),
    );
    print('circle: $circle');
  }

  void _addSymbol(gateway) {
    controller.addSymbol(
      SymbolOptions(
          geometry: LatLng(
            gateway.location.latitude,
            gateway.location.longitude,
          ),
          iconImage: Constants.mbGatewaySymbol,
          textField: 'EUI: ${gateway.id}'),
    );
  }

  @override
  void initState() {
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best);
    final Stream<Position> positionStream =
        Geolocator().getPositionStream(locationOptions);
    _positionStreamSubscription = positionStream.listen(_updatePosition);

    super.initState();
  }

  void _updatePosition(Position position) {
    controller.moveCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
    setState(() => _position = position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: MapboxMap(
              onMapCreated: onMapCreated,
              styleString: Constants.styleString,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.initialPosition.latitude,
                    widget.initialPosition.longitude),
                zoom: Constants.mbDefaultZoomLevel,
              ),
              trackCameraPosition: true,
            ),
          ),
          SessionControl(_onMessageReceived)
        ]);
  }

  @override
  void dispose() {
    controller.removeListener(_onMapChanged);
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  }
}
