import 'package:shared_preferences/shared_preferences.dart';

class RemoteSharedPreference {
  static late SharedPreferences _prefs;
  static const String _messageVersion = 'remote';

  static const String _surveyVersion = 'survey';

  static const String _promotionVersion = 'promotion';

  static const String _updateVersion = 'update';
  static const String _maintenanceVersion = 'maintenance';

  static Future<void> storeMessageVersion(int version) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_messageVersion, version);
  }

  static Future<int> getMessageVersion() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_messageVersion) ?? 0;
  }

  static Future<void> storeSurveyVersion(int version) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_surveyVersion, version);
  }

  static Future<int> getSurveyVersion() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_surveyVersion) ?? 0;
  }

  static Future<void> storePromotionVersion(int version) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_promotionVersion, version);
  }

  static Future<int> getPromotionVersion() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_promotionVersion) ?? 0;
  }

  static Future<void> storeUpdateVersion(int version) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_updateVersion, version);
  }

  static Future<int> getUpdateVersion() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_updateVersion) ?? 0;
  }

  static Future<void> storeMaintenanceVersion(int version) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_maintenanceVersion, version);
  }

  static Future<int> getMaintenanceVersion() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_maintenanceVersion) ?? 0;
  }
}
