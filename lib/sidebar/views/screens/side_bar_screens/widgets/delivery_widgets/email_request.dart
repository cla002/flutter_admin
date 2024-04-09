import 'package:admin_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewRiderRequest extends StatefulWidget {
  const NewRiderRequest({super.key});

  @override
  State<NewRiderRequest> createState() => _NewRiderRequestState();
}

class _NewRiderRequestState extends State<NewRiderRequest> {
  FirebaseServices _services = FirebaseServices();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _services.ridersRequest.snapshots(),
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
              child: Text('No Rider Request'),
            );
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 238, 234, 234)),
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text('Actions'),
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
      return [];
    }

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
        cells: [
          DataCell(
            Text(document['email'] ?? ''),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {
                _deleteEmail(document.id); // Call function to delete email
              },
              child: Text('Delete'),
            ),
          ),
        ],
      );
    }).toList();
    return newList;
  }

  void _deleteEmail(String documentId) async {
    try {
      await _services.ridersRequest.doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email deleted successfully')),
      );
    } catch (e) {
      print('Error deleting email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting email')),
      );
    }
  }
}
