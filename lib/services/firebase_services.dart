import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FirebaseServices {
  Future<QuerySnapshot> getAdminCredentials() {
    var result = FirebaseFirestore.instance.collection('admin').get();
    return result;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference banners =
      FirebaseFirestore.instance.collection('banners');

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference riders = FirebaseFirestore.instance.collection('riders');
  CollectionReference ridersRequest =
      FirebaseFirestore.instance.collection('ridersRequest');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference admins = FirebaseFirestore.instance.collection('admin');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot> getReports() {
    return FirebaseFirestore.instance.collection('reports').get();
  }

  Future<QuerySnapshot> getOrders() async {
    return await FirebaseFirestore.instance.collection('orders').get();
  }

  double calculateTotalSales(String vendorId, QuerySnapshot orderSnapshot) {
    double totalSales = 0;
    for (var doc in orderSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['seller']['sellerId'] == vendorId) {
        totalSales += (data['total'] ?? 0) as double;
      }
    }
    return totalSales;
  }

  updateVendorStatus({id, status}) async {
    vendors.doc(id).update(
      {'accountVerified': status ? false : true},
    );
  }

  updateVendorTop({id, status}) async {
    vendors.doc(id).update(
      {'isTopPicked': status ? false : true},
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  Future<void> saveDeliveryRider(email, password) async {
    riders.doc(email).set({
      'accountVerified': false,
      'address': '',
      'email': email,
      'imageUrl': '',
      'location': GeoPoint(0, 0),
      'mobile': '',
      'name': '',
      'password': 'rider',
      'uid': '',
    });
  }

  Future<void> updateRiderStatus(
      {required String id, required BuildContext context, status}) async {
    EasyLoading.show();
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('riders').doc(id);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        transaction.update(documentReference, {'accountVerified': status});
      });
      EasyLoading.dismiss();
      showMyDialog(
        title: 'Delivery Rider Status',
        message: status == true
            ? "Delivery Rider Status Updated as Approved"
            : "Delivery Rider Status Updated as Not Approved",
        context: context,
      );
    } catch (error) {
      showMyDialog(
        title: 'Delivery Rider Status',
        message: "Failed to update delivery status: $error",
        context: context,
      );
    }
  }

  Future<void> deleteVendor(String vendorId) async {
    EasyLoading.dismiss();
    try {
      await vendors.doc(vendorId).delete();
    } catch (error) {
      print("Error deleting vendor: $error");
      throw error;
    }
  }
}
