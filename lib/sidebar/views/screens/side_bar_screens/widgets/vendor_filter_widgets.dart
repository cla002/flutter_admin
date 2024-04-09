import 'package:admin_app/globals/styles.dart';
import 'package:flutter/material.dart';

class VendorFilterWidget extends StatelessWidget {
  const VendorFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: GlobalStyles.screenWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionChip(
              onPressed: () {},
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'All Vendors',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Activated',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Deactivated',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Top Picked',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Top Rated',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
