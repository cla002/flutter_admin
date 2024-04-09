import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NumberOfProductSold extends StatefulWidget {
  const NumberOfProductSold({Key? key}) : super(key: key);

  @override
  State<NumberOfProductSold> createState() => _NumberOfProductSoldState();
}

class _NumberOfProductSoldState extends State<NumberOfProductSold> {
  Future<int> _getTotalProductsSold() async {
    QuerySnapshot ordersSnapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    int totalProductsSold = 0;
    for (var orderDoc in ordersSnapshot.docs) {
      List<dynamic> products =
          orderDoc['products']; // Assuming 'products' is a list
      for (var product in products) {
        int numberOfItems = product['quantity'];
        totalProductsSold += numberOfItems;
      }
    }
    return totalProductsSold;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.orange.shade900,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: FutureBuilder<int>(
          future: _getTotalProductsSold(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Products Sold',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
