import 'package:base_flutter_template/screens/web/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class WebEntry extends StatelessWidget {
  const WebEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:  DashboardHome());
  }
}
