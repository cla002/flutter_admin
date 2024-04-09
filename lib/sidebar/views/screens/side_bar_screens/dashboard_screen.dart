import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/admin.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/buyers.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/category_list.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/product_sold.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/riders.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/dashboard/seller.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // For smaller screens, display centered content
            return buildCenteredContent();
          } else {
            // For larger screens, display content as it is
            return buildRowLayout();
          }
        },
      ),
    );
  }

  Widget buildCenteredContent() {
    return SingleChildScrollView(
      child: Container(
        alignment:
            Alignment.center, // Center the content vertically and horizontally
        padding: const EdgeInsets.all(10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 20),
            // Widgets displayed in a column for smaller screens
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the widgets horizontally
              children: [
                NumberOfAdmin(),
                SizedBox(
                  height: 5,
                ),
                NumberOfRiders(),
                SizedBox(
                  height: 5,
                ),
                NumberOfBuyers(),
                SizedBox(
                  height: 5,
                ),
                NumberOfSeller(),
                SizedBox(height: 20),
                NumberOfProductSold(),
                SizedBox(
                  height: 5,
                ),
                NumberOfCategories(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowLayout() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26.0,
              ),
            ),
            SizedBox(height: 20),
            // Widgets displayed in a row for larger screens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberOfAdmin(),
                NumberOfRiders(),
                NumberOfBuyers(),
                NumberOfSeller(),
              ],
            ),
            SizedBox(height: 20),
            // Widgets displayed in a row for larger screens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberOfProductSold(),
                NumberOfCategories(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
