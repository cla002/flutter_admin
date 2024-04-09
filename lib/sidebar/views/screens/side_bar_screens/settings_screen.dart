import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  static const String routeName = 'SettingScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
    );
  }
}
