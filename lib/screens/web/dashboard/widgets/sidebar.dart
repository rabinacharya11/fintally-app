import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.onDashboard,
    required this.onExpense,
    required this.onIncome,
    required this.onSettings,
    required this.onLogout,
    required this.onHelp,
  });
  final Function(int index) onDashboard;
  final Function(int index) onExpense;
  final Function(int index) onIncome;
  final Function(int index) onSettings;
  final Function(int index) onLogout;
  final Function(int index) onHelp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 150, color: Theme.of(context).primaryColor),
        ListTile(
          title: Text('Dashboard'),
          leading: Icon(Icons.dashboard),
          onTap: () => onDashboard(0),
        ),
        ListTile(
          title: Text('Expense'),
          leading: Icon(Icons.monetization_on),
          onTap: () => onExpense(1),
        ),
        ListTile(
          title: Text('Income'),
          leading: Icon(Icons.money),
          onTap: () => onIncome(2),
        ),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () => onSettings(3),
        ),
        ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () => onLogout(4),
        ),
        ListTile(
          title: Text('Help'),
          leading: Icon(Icons.help),
          onTap: () => onHelp(5),
        ),
      ],
    );
  }
}
