import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NumberOfSeller extends StatefulWidget {
  const NumberOfSeller({Key? key}) : super(key: key);

  @override
  State<NumberOfSeller> createState() => _NumberOfSellerState();
}

class _NumberOfSellerState extends State<NumberOfSeller> {
  Future<int> _getNumberOfSellers() async {
    QuerySnapshot adminSnapshot =
        await FirebaseFirestore.instance.collection('vendors').get();
    return adminSnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.green.shade900,
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
            future: _getNumberOfSellers(),
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
                      'Verified Sellers',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
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
      ),
    );
  }
}
