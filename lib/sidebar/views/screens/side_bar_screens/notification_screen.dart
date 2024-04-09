import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '\NotificationScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
    );
  }
}
