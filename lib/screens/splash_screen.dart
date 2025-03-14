import 'package:base_flutter_template/di/service_locator.dart';
import 'package:base_flutter_template/services/crashlytics/crashlytics_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class SplashScreen extends StatefulWidget {
  final Widget Function(BuildContext) onInitializationComplete;

  const SplashScreen({Key? key, required this.onInitializationComplete})
    : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize services
      await setupServiceLocator();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize other services
      await Future.wait([
        analyticsService.logAppOpen(),
        analyticsService.logEvent(name: 'app_open'),
        crashlyticsService.initialize(),
        notificationService.initialize(),
      ]);

      // Mark initialization as complete
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e, stackTrace) {
      print('Error during initialization: $e');
      if (serviceLocator.isRegistered<CrashlyticsService>()) {
        crashlyticsService.recordError(e, stackTrace);
      }
      // You might want to show an error state here
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return widget.onInitializationComplete(context);
    }

    // Your splash screen UI
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add your logo here
                FlutterLogo(size: 100),
                SizedBox(height: 24),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  'Initializing...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
