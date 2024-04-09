import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerScreen extends StatefulWidget {
  const BuyerScreen({Key? key}) : super(key: key);

  static const String routeName = 'BuyerScreen';

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  Widget _buildHeader(String text, {double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRowData(
    String? profilePicture,
    String id,
    String fullName,
    String email,
    String number,
    String address,
  ) {
    Widget profileImageWidget;

    if (profilePicture != null && profilePicture.isNotEmpty) {
      profileImageWidget = Image.network(
        profilePicture,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      profileImageWidget = Icon(
        Icons.account_circle,
        size: 50,
        color: Colors.grey,
      );
    }

    return DataRow(
      cells: [
        DataCell(profileImageWidget),
        DataCell(Text(id)),
        DataCell(Text(fullName)),
        DataCell(Text(email)),
        DataCell(Text(number)),
        DataCell(Text(address)),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, id);
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform delete operation here
                _deleteUser(id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String id) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }
          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: _buildHeader('Profile Picture')),
                  DataColumn(label: _buildHeader('ID')),
                  DataColumn(label: _buildHeader('Name')),
                  DataColumn(label: _buildHeader('Email', flex: 2)),
                  DataColumn(label: _buildHeader('Number')),
                  DataColumn(label: _buildHeader('Address', flex: 2)),
                  DataColumn(label: _buildHeader('Remove User')),
                ],
                rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> userData =
                      document.data() as Map<String, dynamic>;
                  String? profilePicture =
                      userData['profilePicture'] as String?;
                  String? firstName = userData['firstName'] as String?;
                  String? lastName = userData['lastName'] as String?;
                  String fullName = '';

                  if (firstName != null && lastName != null) {
                    fullName = '$firstName $lastName';
                  } else if (firstName != null) {
                    fullName = firstName;
                  } else if (lastName != null) {
                    fullName = lastName;
                  }

                  return _buildRowData(
                    profilePicture,
                    document.id,
                    fullName,
                    userData['email'] ?? '',
                    userData['number'] ?? '',
                    userData['address'] ?? '',
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
