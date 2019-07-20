import 'package:meta/meta.dart';

///
/// The settings which can be configure in the app.
///
@immutable
class Settings {
  final DateTime lastUpdatedOn;
  final String mqttBrokerHost;
  final int mqttBrokerPort;
  final String applicationId;
  final String applicationAccessKey;
  final String deviceId;
  final bool doUpload;
  final bool isExperimental;
  final String experimentName;
  final bool shouldStoreLocal;

  Settings({
    this.lastUpdatedOn,
    this.mqttBrokerHost,
    this.mqttBrokerPort,
    this.applicationId,
    this.applicationAccessKey,
    this.deviceId,
    this.doUpload,
    this.isExperimental,
    this.experimentName,
    this.shouldStoreLocal,
  });

  ///
  /// Checks whether the minimal required fields are present in the settings.
  ///
  bool isValid() {
    return this.mqttBrokerHost != null &&
        this.mqttBrokerPort != null &&
        this.applicationId != null &&
        this.applicationAccessKey != null;
  }
}
