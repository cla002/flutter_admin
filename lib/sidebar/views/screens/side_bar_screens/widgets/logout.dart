import 'package:admin_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutUser(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userToken');
  SystemNavigator.pop();
}

Future<void> confirmLogout(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              logoutUser(context);
              Navigator.pushNamed(context, MyHomePage.id);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
