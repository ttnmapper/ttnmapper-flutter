import 'package:mapbox_gl/mapbox_gl.dart';

class Constants {
  static const appTitle = 'TTN Mapper';
  static const primaryColor = 0xFF0D5E97;

  // Mapbox configuration.
  static const String styleString = MapboxStyles.LIGHT;
  static const double mbDefaultZoomLevel =  14.0;
  static const String mbGatewaySymbol = 'ttnmapper-gateway-icon.png';

  // MQTT default configuration parameters
  static const String mqttDefaultClientId = 'ttnmapper_mqtt_client';
  static const int mqttDefaultBrokerPort = 1883;
  static const int mqttDefaultKeepAlive = 60;
}