import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VendorDetails extends StatefulWidget {
  final String uid;
  VendorDetails(this.uid);

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  FirebaseServices _services = FirebaseServices();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _vendorFuture;
  late Future<QuerySnapshot> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _vendorFuture = _services.vendors.doc(widget.uid).get()
        as Future<DocumentSnapshot<Map<String, dynamic>>>;
    _ordersFuture = _services.getOrders();
  }

  int countOrders(List<DocumentSnapshot> orders) {
    int count = 0;
    for (var order in orders) {
      String status = order['orderStatus'];
      if (status == 'Accepted' ||
          status == 'Picked Up' ||
          status == 'On the Way') {
        count++;
      }
    }
    return count;
  }

  int countTotalOrders(List<DocumentSnapshot> orders) {
    int count = 0;
    for (var order in orders) {
      String status = order['orderStatus'];
      if (status == 'Accepted' ||
          status == 'Picked Up' ||
          status == 'On the Way' ||
          status == 'Delivered') {
        count++;
      }
    }
    return count;
  }

  double calculateTotalRevenueForVendor(
      List<DocumentSnapshot> orders, String vendorId) {
    double totalRevenue = 0;
    for (var order in orders) {
      // Check if the order belongs to the specific vendor
      if (order.data() != null &&
          (order.data() as Map<String, dynamic>)['seller']['sellerId'] ==
              vendorId &&
          (order.data() as Map<String, dynamic>).containsKey('total')) {
        double? price = (order.data() as Map<String, dynamic>)['total'];
        if (price != null) {
          totalRevenue += price;
        }
      }
    }
    return totalRevenue;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _vendorFuture,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          return FutureBuilder<QuerySnapshot>(
            future: _ordersFuture,
            builder: (context, orderSnapshot) {
              if (orderSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (orderSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${orderSnapshot.error}'),
                );
              }
              int acceptedOrdersCount = countOrders(orderSnapshot.data!.docs);
              int totalOrdersCount = countTotalOrders(orderSnapshot.data!.docs);

              double totalRevenue = calculateTotalRevenueForVendor(
                  orderSnapshot.data!.docs, widget.uid);

              return Dialog(
                child: SingleChildScrollView(
                  child: Container(
                    height: GlobalStyles.screenHeight(context),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                data['imageUrl'] ?? '',
                                fit: BoxFit.cover,
                                height: 200,
                                width: 200,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    data['shopName'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, top: 10),
                                    child: Text(
                                      data['dialog'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: const Text(
                              'Account  Status :',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: snapshot.data!['accountVerified']
                                ? const Chip(
                                    label: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: const Chip(
                                      label: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Not Verified',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: const Text(
                              'Top Picked Status :',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: snapshot.data!['isTopPicked']
                                ? const Chip(
                                    label: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Top Picked',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: const Chip(
                                      label: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Not Pick',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(thickness: 3),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const Text(
                                'Contact Number :',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['mobile'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Email :',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['email'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Address :',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['address'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.money_dollar,
                                            size: 50,
                                          ),
                                          Text(
                                              "₱${totalRevenue.toStringAsFixed(2)}")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.shopping_basket_outlined,
                                            size: 50,
                                          ),
                                          const Text('Active Orders'),
                                          Text(acceptedOrdersCount.toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 50,
                                          ),
                                          const Text('Total Orders'),
                                          Text(totalOrdersCount.toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
