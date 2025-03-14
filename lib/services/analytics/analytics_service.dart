import 'package:firebase_analytics/firebase_analytics.dart';

/// Provides Firebase Analytics functionality for tracking user events and screen views
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Get the FirebaseAnalytics instance
  FirebaseAnalytics get analytics => _analytics;

  /// Get an observer for navigation to automatically track screen views
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  /// Log a custom event with optional parameters
  ///
  /// [name] The name of the event to log
  /// [parameters] Optional parameters for the event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Failed to log event: ${e.toString()}');
    }
  }

  /// Log a screen view event
  ///
  /// [screenName] The name of the screen being viewed
  /// [screenClass] The class name of the screen being viewed
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      print('Failed to log screen view: ${e.toString()}');
    }
  }

  /// Log a user sign-up event
  ///
  /// [method] The sign-up method used (e.g., 'email', 'google')
  Future<void> logSignUp({required String method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (e) {
      print('Failed to log sign up: ${e.toString()}');
    }
  }

  /// Log a user login event
  ///
  /// [method] The login method used (e.g., 'email', 'google')
  Future<void> logLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      print('Failed to log login: ${e.toString()}');
    }
  }

  /// Log an e-commerce purchase event
  ///
  /// [currency] Currency code (e.g., 'USD')
  /// [value] Purchase value
  /// [transactionId] Unique transaction ID
  /// [items] List of purchased items
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String transactionId,
    List<AnalyticsEventItem>? items,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        items: items,
      );
    } catch (e) {
      print('Failed to log purchase: ${e.toString()}');
    }
  }

  /// Log an app open event
  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (e) {
      print('Failed to log app open: ${e.toString()}');
    }
  }

  /// Log search event
  ///
  /// [searchTerm] The search term used
  Future<void> logSearch({required String searchTerm}) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
    } catch (e) {
      print('Failed to log search: ${e.toString()}');
    }
  }

  /// Log select content event
  ///
  /// [contentType] The type of content selected
  /// [itemId] The ID of the selected item
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    try {
      await _analytics.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );
    } catch (e) {
      print('Failed to log select content: ${e.toString()}');
    }
  }

  /// Log share event
  ///
  /// [contentType] The type of content shared
  /// [itemId] The ID of the shared item
  /// [method] The method used to share
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method,
      );
    } catch (e) {
      print('Failed to log share: ${e.toString()}');
    }
  }

  /// Set a user property
  ///
  /// [name] The name of the user property
  /// [value] The value of the user property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Failed to set user property: ${e.toString()}');
    }
  }

  /// Set the user ID for analytics
  ///
  /// [id] The user's ID, or null to remove the ID
  Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (e) {
      print('Failed to set user ID: ${e.toString()}');
    }
  }

  /// Reset all analytics data for the current user
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
    } catch (e) {
      print('Failed to reset analytics data: ${e.toString()}');
    }
  }

  /// Set analytics collection enabled or disabled
  ///
  /// [enabled] Whether analytics collection should be enabled
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      print('Failed to set analytics collection enabled: ${e.toString()}');
    }
  }

  /// Log a custom timing event
  ///
  /// [name] The name of the timed event
  /// [milliseconds] The time in milliseconds
  Future<void> logTiming({
    required String name,
    required int milliseconds,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'timing_$name',
        parameters: {'time_in_ms': milliseconds},
      );
    } catch (e) {
      print('Failed to log timing: ${e.toString()}');
    }
  }
}
