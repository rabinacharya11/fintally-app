import 'package:base_flutter_template/screens/web/dashboard/dashboard_page.dart';
import 'package:base_flutter_template/screens/web/dashboard/expense_dart.dart';
import 'package:base_flutter_template/screens/web/dashboard/help.dart';
import 'package:base_flutter_template/screens/web/dashboard/income_dart.dart';
import 'package:base_flutter_template/screens/web/dashboard/settings_page.dart';
import 'package:base_flutter_template/screens/web/dashboard/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class DashboardHome extends StatelessWidget {
  DashboardHome({super.key});

  final _viewIndex = ValueNotifier<int>(0);

  final _pages = [
    const DashboardPage(),
    const ExpensePage(),
    const IncomePage(),
    const SettingsPage(),
    const Text("Logout"),
    const HelpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Sidebar(
              onDashboard: (index) {
                _viewIndex.value = 0;
              },
              onExpense: (index) {
                _viewIndex.value = 1;
              },
              onIncome: (index) {
                _viewIndex.value = 2;
              },
              onSettings: (index) {
                _viewIndex.value = 3;
              },
              onLogout: (index) {
                _viewIndex.value = 4;
              },
              onHelp: (index) {
                _viewIndex.value = 5;
              },
            ),
          ),
          Expanded(
            flex: 12,
            child: ValueListenableBuilder(
              valueListenable: _viewIndex,
              builder: (context, value, child) {
                return _pages[value];
              },
            ),
          ),
        ],
      ),
    );
  }
}
