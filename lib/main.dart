import 'dart:io';

import 'package:base_flutter_template/config/firebase_options.dart';
import 'package:base_flutter_template/screens/splash_screen.dart';
import 'package:base_flutter_template/di/service_locator.dart';
import 'package:base_flutter_template/services/analytics/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove Firebase initialization from here as it's already initialized in SplashScreen

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onInitializationComplete:
          (context) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    try {
      // Always update UI state first
      setState(() {
        _counter++;
      });

      // Then handle analytics and auth (which might take time)
      if (analyticsService != null) {
        analyticsService.logEvent(name: 'button_pressed');
        analyticsService.logEvent(
          name: 'button_pressed',
          parameters: {'counter': _counter},
        );

        analyticsService.logLogin(method: 'email');
        analyticsService.logTiming(name: 'button_pressed', milliseconds: 1000);
      }

      // Handle Google Sign-In
      if (authService != null) {
        final userCredential = await authService.signInWithGoogle();

        if (userCredential != null) {
          // Successfully signed in
          print('Signed in: ${userCredential.user?.displayName}');
        } else {
          // User canceled sign-in
          print('Sign-in canceled by user');
        }
      }
    } catch (e, stackTrace) {
      // Log any errors to crashlytics and console
      print('Error during sign-in: $e');
      if (crashlyticsService != null) {
        crashlyticsService.recordError(e, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
