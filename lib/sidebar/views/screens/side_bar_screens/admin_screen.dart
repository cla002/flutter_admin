import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/add_admin.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/admin_list.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  static const String routeName = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Admins',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
      body: Container(
        width: GlobalStyles.screenWidth(context),
        height: GlobalStyles.screenHeight(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddNewAdmin(),
              const SizedBox(height: 10),
              const Divider(
                thickness: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Admin List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: AdminList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
