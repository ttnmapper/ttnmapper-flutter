import 'package:flutter/material.dart';
import 'package:ttnmapper_app/models/settings.dart';
import 'package:ttnmapper_app/services/mqtt_service.dart';
import 'package:ttnmapper_app/services/preference_service.dart';

import '../constants.dart';

class SessionControl extends StatefulWidget {
  final Function(String) onMessageReceived;

  SessionControl(this.onMessageReceived);

  @override
  State<StatefulWidget> createState() => _SessionControlState();
}

class _SessionControlState extends State<SessionControl> {
  Settings _settings;
  MqttService _mqttService;
  String _sessionStateInformation = 'Configure your settings before mapping';
  bool _sessionSwitchToggled = false;
  bool _connected = false;

  @override
  void initState() {
    print('initState');

    PreferenceService.load().then((settings) {
      setState(() {
        this._settings = settings;
      });
    });

    super.initState();
  }

  void _onSessionSwitchToggled(bool isToggled) {
    print('toggled');

    if (isToggled) {
      String deviceId = _settings.deviceId != null ? _settings.deviceId : '+';

      _mqttService = MqttService(
        brokerHost: _settings.mqttBrokerHost,
        brokerPort: _settings.mqttBrokerPort,
        username: _settings.applicationId,
        password: _settings.applicationAccessKey,
        topic: '${_settings.applicationId}/devices/$deviceId/up',
      );
      setState(() {
        _sessionStateInformation = 'Connecting (${_mqttService.brokerHost})...';
      });
      _mqttService.connect(
        onConnect: () {
          print('MQTT: Connected');
          final snackBar = SnackBar(
            content: Text('Succesfully connected!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.green.shade100,
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
          setState(() {
            _sessionStateInformation =
                'Connected to ${_mqttService.brokerHost}';
            _connected = true;
          });
        },
        onDisconnect: () {
          print('MQTT: Disconnected');
          setState(() {
            _sessionStateInformation =
                'Disconnected from ${_mqttService.brokerHost}';
            _connected = false;
          });
        },
        onError: () {
          print('MQTT: Error');
          final snackBar = SnackBar(
            content: Text('Connection error: ${_mqttService.brokerHost}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.red.shade100,
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);

          setState(() {
            _sessionSwitchToggled = false;
          });
        },
        onSubscribe: (topic) => print('MQTT: Subscribed on $topic'),
        onMessageReceived: widget.onMessageReceived,
      );
    } else {
      _mqttService.disconnect();
    }
    setState(() {
      //TODO: Trigger session start and stop.
      _sessionSwitchToggled = isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Container(
        color: _settings != null && _settings.isValid()
            ? Color(Constants.primaryColor)
            : Colors.orange,
        height: 48.0,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 14.0),
                  child: Text(
                    _sessionStateInformation,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Switch(
                  value: _sessionSwitchToggled,
                  activeColor: Colors.white,
                  activeTrackColor: _connected ? Colors.green : Colors.orange,
                  onChanged: _settings != null && _settings.isValid()
                      ? _onSessionSwitchToggled
                      : null),
            ]));
  }
}
