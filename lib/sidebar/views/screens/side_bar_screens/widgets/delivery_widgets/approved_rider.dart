import 'package:admin_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedDeliveryRider extends StatefulWidget {
  const ApprovedDeliveryRider({Key? key});

  @override
  State<ApprovedDeliveryRider> createState() => _ApprovedDeliveryRiderState();
}

class _ApprovedDeliveryRiderState extends State<ApprovedDeliveryRider> {
  FirebaseServices _services = FirebaseServices();
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _services.riders
            .where('accountVerified', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No internet connection'),
            );
          } else if (snapshot.hasError) {
            return const Text('Something went wrong...');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Approved Delivery Rider'),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 238, 234, 234)),
              columns: const <DataColumn>[
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Profile Image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Mobile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              rows: _riderList(snapshot.data),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _riderList(QuerySnapshot? snapshot) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return []; // Return an empty list if snapshot is null or empty
    }

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
        cells: [
          DataCell(
            Container(
              width: 50,
              height: 50,
              child: Image.network(
                document['imageUrl'] ?? '',
                fit: BoxFit.fill,
              ),
            ),
          ),
          DataCell(
            SizedBox(
              width: 160,
              child: Text(document['name'] ?? ''),
            ),
          ),
          DataCell(
            SizedBox(
              width: 200,
              child: Text(document['email'] ?? ''),
            ),
          ),
          DataCell(
            SizedBox(
              width: 100,
              child: Text(document['mobile'] ?? ''),
            ),
          ),
          DataCell(
            SizedBox(
              width: 400,
              child: Text(document['address'] ?? ''),
            ),
          ),
          DataCell(
            SizedBox(
              width: 150,
              child: FlutterSwitch(
                activeText: 'Approved',
                inactiveText: 'Waiting',
                width: 120.0,
                height: 40.0,
                valueFontSize: 16,
                value: document['accountVerified'] ?? false,
                showOnOff: true,
                onToggle: (val) {
                  _services.updateRiderStatus(
                      id: document.id, context: context, status: false);
                },
              ),
            ),
          ),
        ],
      );
    }).toList();
    return newList;
  }
}
