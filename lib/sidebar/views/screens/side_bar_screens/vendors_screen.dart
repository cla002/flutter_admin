import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/vendor_data_table..dart';
import 'package:flutter/material.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  static const String routeName = 'VendorScreen';

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Vendors',
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
          const VendorDataTable(),
        ],
      ),
    );
  }
}
