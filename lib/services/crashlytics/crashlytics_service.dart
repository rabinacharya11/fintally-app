import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Provides Firebase Crashlytics functionality for reporting crashes and errors
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Get the FirebaseCrashlytics instance
  FirebaseCrashlytics get crashlytics => _crashlytics;

  /// Initialize Crashlytics and set up error handling
  ///
  /// This should be called early in the app initialization
  Future<void> initialize() async {
    // Pass all uncaught asynchronous errors to Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Pass all uncaught errors from the framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    // Only enable Crashlytics in non-debug mode by default
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  /// Set whether Crashlytics collection is enabled
  ///
  /// [enabled] Whether Crashlytics should collect crash reports
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  /// Log a message to Crashlytics
  ///
  /// Useful for adding custom logs to crash reports
  /// [message] The message to log
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Record a non-fatal error to Crashlytics
  ///
  /// [exception] The error or exception to record
  /// [stack] The stack trace associated with the error
  /// [reason] An optional reason for the error
  /// [fatal] Whether the error was fatal to the app
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Record a Flutter error to Crashlytics
  ///
  /// [flutterError] The Flutter error to record
  Future<void> recordFlutterError(FlutterErrorDetails flutterError) async {
    await _crashlytics.recordFlutterError(flutterError);
  }

  /// Set a custom key and value to be associated with crash reports
  ///
  /// [key] The key for this custom attribute
  /// [value] The value for this custom attribute
  Future<void> setCustomKey(String key, dynamic value) async {
    if (value is int) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is double) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is bool) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is String) {
      await _crashlytics.setCustomKey(key, value);
    } else {
      await _crashlytics.setCustomKey(key, value.toString());
    }
  }

  /// Set user identifier for crash reports
  ///
  /// [identifier] The user identifier to be associated with crash reports
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Force a crash for testing Crashlytics
  ///
  /// Only use this in testing environments!
  void crash() {
    _crashlytics.crash();
  }

  /// Clear all collected crash reports that haven't been sent yet
  Future<void> deleteUnsentReports() async {
    await _crashlytics.deleteUnsentReports();
  }

  /// Check if there are any unsent crash reports
  Future<bool> didCrashOnPreviousExecution() async {
    return await _crashlytics.didCrashOnPreviousExecution();
  }

  /// Send any unsent crash reports to Crashlytics
  Future<void> sendUnsentReports() async {
    await _crashlytics.sendUnsentReports();
  }

  /// Wrapper to capture zone errors for custom code execution
  ///
  /// [body] The function to run inside the error zone
  Future<T> runZonedGuarded<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (error, stackTrace) {
      await recordError(error, stackTrace);
      rethrow;
    }
  }
}
