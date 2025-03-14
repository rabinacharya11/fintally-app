import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import '../config/firebase_options.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';
import '../services/analytics/analytics_service.dart';
import '../services/crashlytics/crashlytics_service.dart';
// import '../services/remote_config/remote_config_service.dart';
import '../services/server_file_storage/cloudinary_service.dart';
import '../services/notifications/notification_service.dart';
// import '../services/theme/theme_service.dart';
// import '../providers/theme_provider.dart';

/// Global ServiceLocator instance
final serviceLocator = GetIt.instance;

/// Initialize Firebase and register all services
/// This should be called in main() before runApp()
Future<void> setupServiceLocator() async {
  // Firebase should be initialized in main.dart before this method is called
  // We just register the services here

  // Register all Firebase services
  _registerServices();

  // // Initialize services that need initialization
  // await serviceLocator<RemoteConfigService>().initialize();
  // await serviceLocator<ThemeService>().initialize();
}

/// Register all service implementations
void _registerServices() {
  // Auth Service
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  // Database Service
  serviceLocator.registerLazySingleton<DatabaseService>(
    () => DatabaseService(),
  );

  // Analytics Service
  serviceLocator.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(),
  );

  // Crashlytics Service
  serviceLocator.registerLazySingleton<CrashlyticsService>(
    () => CrashlyticsService(),
  );

  // // Remote Config Service
  // serviceLocator.registerLazySingleton<RemoteConfigService>(
  //   () => RemoteConfigService(),
  // );

  // Cloudinary Service (for file storage)
  serviceLocator.registerLazySingleton<CloudinaryService>(
    () => CloudinaryService(),
  );

  // Notification Service
  serviceLocator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  // // Theme Service
  // serviceLocator.registerLazySingleton<ThemeService>(() => ThemeService());

  // // Theme Provider
  // serviceLocator.registerLazySingleton<ThemeProvider>(
  //   () => ThemeProvider(serviceLocator<ThemeService>()),
  // );
}

/// Firebase Services singleton instance accessors

/// Get AuthService instance
AuthService get authService => serviceLocator<AuthService>();

/// Get DatabaseService instance
DatabaseService get databaseService => serviceLocator<DatabaseService>();

/// Get AnalyticsService instance
AnalyticsService get analyticsService => serviceLocator<AnalyticsService>();

/// Get CrashlyticsService instance
CrashlyticsService get crashlyticsService =>
    serviceLocator<CrashlyticsService>();

// /// Get RemoteConfigService instance
// RemoteConfigService get remoteConfigService =>
//     serviceLocator<RemoteConfigService>();

/// Get CloudinaryService instance for file storage
CloudinaryService get cloudinaryService => serviceLocator<CloudinaryService>();

/// Get NotificationService instance
NotificationService get notificationService =>
    serviceLocator<NotificationService>();

// /// Get ThemeService instance
// ThemeService get themeService => serviceLocator<ThemeService>();

  // /// Get ThemeProvider instance
  // ThemeProvider get themeProvider => serviceLocator<ThemeProvider>();
