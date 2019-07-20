import 'package:mqtt_client/mqtt_client.dart' as mqtt;

import '../constants.dart';

class MqttService {
  final String clientId;
  final String brokerHost;
  final int brokerPort;
  final int keepAlive;
  final String username;
  final String password;
  final String topic;

  MqttService(
      {this.clientId = Constants.mqttDefaultClientId,
      this.brokerHost,
      this.brokerPort = Constants.mqttDefaultBrokerPort,
      this.keepAlive = Constants.mqttDefaultKeepAlive,
      this.username,
      this.password,
      this.topic});

  mqtt.MqttClient _client;

  /// Connects to the MQTT broker.
  void connect(
      {onConnect(),
      onSubscribe(String topic),
      onPublish(List<int> message),
      onMessageReceived(String message),
      onDisconnect(),
      onError()}) async {
    // Initialize an MQTT client.
    _client = mqtt.MqttClient.withPort(brokerHost, clientId, brokerPort);
    _client.keepAlivePeriod = keepAlive;
    _client.logging(on: false);

    // Set callbacks.
    _client.onDisconnected = onDisconnect;
    _client.onConnected = onConnect;

    // Connect to broker with the following configuration.
    _client.connectionMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .keepAliveFor(keepAlive)
        .authenticateAs(username, password)
        .startClean()
        .withWillQos(mqtt.MqttQos.atMostOnce);

    try {
      mqtt.MqttClientConnectionStatus connectionStatus =
          await _client.connect(username, password);

      if (connectionStatus.state == mqtt.MqttConnectionState.connected) {
        // Subscribe to the device topic.
        _client.subscribe(topic, mqtt.MqttQos.atMostOnce);
        if (onSubscribe != null) {
          onSubscribe(topic);
        }

        // Set the onMessageReceived callback for updates from the broker.
        _client.updates.listen((List<mqtt.MqttReceivedMessage> c) {
          final mqtt.MqttPublishMessage message =
              c[0].payload as mqtt.MqttPublishMessage;
          final String payload = mqtt.MqttPublishPayload.bytesToStringAsString(
              message.payload.message);

          if (onMessageReceived != null) {
            onMessageReceived(payload);
          }
        });
      } else {
        // Notify about error in connection.
        if (onError != null) {
          onError();
        }
      }
    } catch (e) {
      print("could not connect: $e");
      disconnect();
      if (onError != null) {
        onError();
      }
    }
  }

  /// Disconnects from the MQTT broker.
  void disconnect() async {
    // Let's unsubscribe first.
    _client.unsubscribe(topic);

    /// Wait for the unsubscribe message from the broker if you wish.
    _client.disconnect();
  }
}
