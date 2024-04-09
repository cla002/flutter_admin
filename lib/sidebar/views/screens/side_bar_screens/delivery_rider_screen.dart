// ignore_for_file: unused_field

import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/delivery_widgets/approved_rider.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/delivery_widgets/create_rider.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/delivery_widgets/email_request.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/delivery_widgets/new_rider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class DeliveryRiderScreen extends StatelessWidget {
  static const String routeName = 'DeliveryRiderScreen';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AdminScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: GlobalStyles.screenHeight(context) * 0.03,
                  vertical: GlobalStyles.screenHeight(context) * 0.01,
                ),
                child: const Text(
                  'Delivery Rider',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26.0,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const CreateNewDeliveryRider(),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const TabBar(
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Text('NEW RIDER REQUEST'),
                  ),
                  Tab(
                    text: 'NEW RIDERS',
                  ),
                  Tab(
                    text: 'APPROVED RIDERS',
                  ),
                ],
              ),
              // Use SizedBox to provide constraints for TabBarView
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: const TabBarView(
                  children: [
                    NewRiderRequest(),
                    NewDeliveryRider(),
                    ApprovedDeliveryRider(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
