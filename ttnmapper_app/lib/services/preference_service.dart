import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttnmapper_app/models/settings.dart';

class PreferenceService {
  static const _keyApplicationId = 'applicationId';
  static const _keyApplicationAccessKey = 'applicationAccessKey';
  static const _keyLastUpdatedOn = 'lastUpdatedOn';

  static void persist(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApplicationId, settings.applicationId);
    await prefs.setString(
        _keyApplicationAccessKey, settings.applicationAccessKey);

    await prefs.setString(_keyLastUpdatedOn, DateTime.now().toIso8601String());
  }

  static Future<Settings> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String applicationId = prefs.getString(_keyApplicationId);
    String applicationAccessKey = prefs.getString(_keyApplicationAccessKey);
    String lastUpdatedOnString = prefs.getString(_keyLastUpdatedOn);

    return Settings(
      applicationId: applicationId,
      applicationAccessKey: applicationAccessKey,
      lastUpdatedOn: lastUpdatedOnString != null
          ? DateTime.parse(lastUpdatedOnString)
          : null,
      mqttBrokerHost: 'eu.thethings.network',
      mqttBrokerPort: 1883,
    );
  }
}
