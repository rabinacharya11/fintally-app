import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.red,
          child: Row(children: [Text('Dashboard')]),
        ),
      ),
      body: Center(child: Text('Dashboard')),
    );
  }
}
