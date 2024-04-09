import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/services/firebase_services.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/vendor_details.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VendorDataTable extends StatefulWidget {
  const VendorDataTable({Key? key}) : super(key: key);

  @override
  State<VendorDataTable> createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {
  FirebaseServices _services = FirebaseServices();
  int tag = 0;
  List<String> options = [
    'All Vendors',
    'Active Vendors',
    'Inactive Vendors',
    'Top Picked',
    'Top Rated',
  ];

  late bool? activeVendors = null;
  late bool? topPicked = null;

  filter(val) {
    if (val == 1) {
      setState(() {
        activeVendors = true;
        topPicked = null;
      });
    } else if (val == 2) {
      setState(() {
        activeVendors = false;
        topPicked = null;
      });
    } else if (val == 3) {
      setState(() {
        topPicked = true;
        activeVendors = null;
      });
    } else {
      setState(() {
        topPicked = null;
        activeVendors = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(val);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        StreamBuilder(
          stream: _services.vendors
              .where('isTopPicked', isEqualTo: topPicked)
              .where('accountVerified', isEqualTo: activeVendors)
              .snapshots(),
          builder: (context, vendorSnapshot) {
            if (vendorSnapshot.hasError) {
              return const Text('Something Went Wrong');
            }
            if (vendorSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FutureBuilder<QuerySnapshot>(
              future: _services.getOrders(),
              builder: (context, orderSnapshot) {
                if (orderSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (orderSnapshot.hasError) {
                    return Text('Error: ${orderSnapshot.error}');
                  } else {
                    return FutureBuilder<QuerySnapshot>(
                      future: _services.getReports(), // Fetch all reports
                      builder: (context, reportSnapshot) {
                        if (reportSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (reportSnapshot.hasError) {
                            return Text('Error: ${reportSnapshot.error}');
                          } else {
                            return SingleChildScrollView(
                              child: Container(
                                width: GlobalStyles.screenWidth(context),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    showBottomBorder: true,
                                    dataRowHeight: 60,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                            'Seller ID'), // New column for Seller ID
                                      ),
                                      DataColumn(
                                        label: Text('Activate/Deactivate'),
                                      ),
                                      DataColumn(
                                        label: Text('Top Picked'),
                                      ),
                                      DataColumn(
                                        label: Text('Shop Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Rating'),
                                      ),
                                      DataColumn(
                                        label: Text('Total Sales'),
                                      ),
                                      DataColumn(
                                        label: Text('Email'),
                                      ),
                                      DataColumn(
                                        label: Text('Mobile'),
                                      ),
                                      DataColumn(
                                        label: Text('View Details'),
                                      ),
                                      DataColumn(
                                        label: Text(
                                            'Reports'), // New column for reports
                                      ),
                                      DataColumn(
                                        label: Text('Delete'),
                                      ),
                                    ],
                                    rows: _vendorDetailRows(
                                      vendorSnapshot.data as QuerySnapshot,
                                      orderSnapshot.data!,
                                      reportSnapshot.data!, // Pass report data
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  }
                }
              },
            );
          },
        ),
      ],
    );
  }

  List<DataRow> _vendorDetailRows(
    QuerySnapshot vendorSnapshot,
    QuerySnapshot orderSnapshot,
    QuerySnapshot reportSnapshot,
  ) {
    // Sort vendors based on total sales
    List<DocumentSnapshot> sortedVendors = vendorSnapshot.docs.toList();
    sortedVendors.sort((a, b) {
      double totalSalesA =
          _services.calculateTotalSales(a['uid'], orderSnapshot);
      double totalSalesB =
          _services.calculateTotalSales(b['uid'], orderSnapshot);
      return totalSalesB.compareTo(totalSalesA); // Descending order
    });

    return sortedVendors.map((DocumentSnapshot vendorDoc) {
      Map<String, dynamic>? vendorData =
          vendorDoc.data() as Map<String, dynamic>?;

      bool accountVerified = vendorData?['accountVerified'] ?? false;
      bool isTopPicked = vendorData?['isTopPicked'] ?? false;
      String shopName = vendorData?['shopName'] as String? ?? '';
      String email = vendorData?['email'] as String? ?? '';
      String mobile = vendorData?['mobile'] as String? ?? '';
      String uid = vendorData?['uid'] as String? ?? '';

      double totalSales = _services.calculateTotalSales(uid, orderSnapshot);

      // Get the number of reports for the current vendor
      int numReports = reportSnapshot.docs
          .where((reportDoc) => reportDoc['sellerId'] == uid)
          .length;

      return DataRow(
        cells: [
          DataCell(
            Text(uid), // Display the seller ID
          ),
          DataCell(
            IconButton(
              onPressed: () {
                _services.updateVendorStatus(
                  id: uid,
                  status: accountVerified,
                );
              },
              icon: accountVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.remove_circle, color: Colors.red),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                _services.updateVendorTop(
                  id: uid,
                  status: isTopPicked,
                );
              },
              icon: isTopPicked
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(null),
            ),
          ),
          DataCell(
            Text(shopName),
          ),
          const DataCell(
            Row(
              children: [
                Icon(Icons.star),
                Text('3.5'),
              ],
            ),
          ),
          DataCell(
            Text("₱${totalSales.toStringAsFixed(2)}"),
          ),
          DataCell(
            Text(email),
          ),
          DataCell(
            Text("+63${mobile}"),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VendorDetails(uid);
                  },
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ),
          DataCell(
            Text(numReports.toString()), // Display the number of reports
          ),
          DataCell(
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text('Are you sure you want to delete?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            EasyLoading.show(status: 'Deleting...');
                            _services.deleteVendor(uid);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      );
    }).toList();
  }
}
