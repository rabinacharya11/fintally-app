import 'package:base_flutter_template/const/responsive_platfrom.dart';
import 'package:base_flutter_template/screens/web/web_entry.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final ResponsivePlatfrom responsivePlatfrom;
  const ResponsiveBuilder({super.key, required this.responsivePlatfrom});

  @override
  Widget build(BuildContext context) { 
    if(responsivePlatfrom == ResponsivePlatfrom.web) {
      return  const WebEntry();
    }

    return const Placeholder();
  }
}
