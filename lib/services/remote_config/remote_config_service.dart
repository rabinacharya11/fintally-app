import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Provides Firebase Remote Config functionality for feature flags and dynamic configuration
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Stream of remote config changes
  Stream<RemoteConfigUpdate> get configUpdates => _remoteConfig.onConfigUpdated;

  /// Default values for remote config parameters
  /// Used when remote values are not available
  final Map<String, dynamic> _defaults = {
    // Add your default values here
    'welcome_message': 'Welcome to the app!',
    'show_new_feature': false,
    'app_theme': 'light',
    'api_timeout_seconds': 30,
    'max_items_per_page': 20,
  };

  /// Initialize the Remote Config service
  ///
  /// [fetchTimeout] Timeout for fetching configs in seconds
  /// [minimumFetchInterval] Minimum interval between fetches in seconds
  Future<void> initialize({
    int fetchTimeout = 10,
    int minimumFetchInterval = 3600, // Default: 1 hour
  }) async {
    try {
      // Set timeout and minimum fetch interval
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: fetchTimeout),
          minimumFetchInterval: Duration(seconds: minimumFetchInterval),
        ),
      );

      // Set default values
      final convertedDefaults = <String, dynamic>{};
      _defaults.forEach((key, value) {
        if (value is String) {
          convertedDefaults[key] = value;
        } else {
          convertedDefaults[key] = value.toString();
        }
      });

      await _remoteConfig.setDefaults(convertedDefaults);

      // Listen to remote config updates
      configUpdates.listen((RemoteConfigUpdate update) {
        // Handle updated keys
        for (final key in update.updatedKeys) {
          print('Remote config updated: $key = ${_remoteConfig.getValue(key)}');
        }
      });

      // Fetch and activate
      await fetchAndActivate();
    } catch (e) {
      print('Failed to initialize Remote Config: ${e.toString()}');
    }
  }

  /// Fetch and activate remote configuration
  ///
  /// Returns true if fetch and activate succeed, false otherwise
  Future<bool> fetchAndActivate() async {
    try {
      // Fetch the latest values from the server
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Failed to fetch remote config: ${e.toString()}');
      return false;
    }
  }

  /// Get a string value from remote config
  ///
  /// [key] The key for the remote config parameter
  /// [defaultValue] The default value to return if the key is not found
  String getString(String key, {String defaultValue = ''}) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      print('Failed to get string for key $key: ${e.toString()}');
      return defaultValue;
    }
  }

  /// Get a boolean value from remote config
  ///
  /// [key] The key for the remote config parameter
  /// [defaultValue] The default value to return if the key is not found
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      print('Failed to get bool for key $key: ${e.toString()}');
      return defaultValue;
    }
  }

  /// Get an integer value from remote config
  ///
  /// [key] The key for the remote config parameter
  /// [defaultValue] The default value to return if the key is not found
  int getInt(String key, {int defaultValue = 0}) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      print('Failed to get int for key $key: ${e.toString()}');
      return defaultValue;
    }
  }

  /// Get a double value from remote config
  ///
  /// [key] The key for the remote config parameter
  /// [defaultValue] The default value to return if the key is not found
  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      print('Failed to get double for key $key: ${e.toString()}');
      return defaultValue;
    }
  }

  /// Get a value from remote config
  ///
  /// [key] The key for the remote config parameter
  /// Returns the RemoteConfigValue object
  RemoteConfigValue getValue(String key) {
    try {
      return _remoteConfig.getValue(key);
    } catch (e) {
      print('Failed to get value for key $key: ${e.toString()}');
      // In newer versions of Firebase, we can't create a RemoteConfigValue directly
      // Return an existing value or use getString to get a default value
      return _remoteConfig.getValue('welcome_message');
    }
  }

  /// Get all remote config parameters
  ///
  /// Returns a Map of all parameter keys and values
  Map<String, RemoteConfigValue> getAll() {
    try {
      return _remoteConfig.getAll();
    } catch (e) {
      print('Failed to get all remote config values: ${e.toString()}');
      return {};
    }
  }

  /// Check if a feature is enabled via remote config
  ///
  /// [featureKey] The key for the feature flag
  /// [defaultValue] The default value if the key is not found
  bool isFeatureEnabled(String featureKey, {bool defaultValue = false}) {
    return getBool(featureKey, defaultValue: defaultValue);
  }

  /// Get the last fetch status
  RemoteConfigFetchStatus get lastFetchStatus => _remoteConfig.lastFetchStatus;

  /// Get the time of the last successful fetch
  DateTime get lastFetchTime => _remoteConfig.lastFetchTime;

  /// Get the Firebase Remote Config instance
  FirebaseRemoteConfig get remoteConfig => _remoteConfig;
}
