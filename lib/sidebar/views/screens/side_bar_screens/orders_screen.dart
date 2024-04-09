import 'package:admin_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chips_choice/chips_choice.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = 'OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  FirebaseServices _services = FirebaseServices();
  late List<String> _options;
  late int _tag;

  @override
  void initState() {
    super.initState();
    _options = [
      'All Orders',
      'Ordered',
      'Picked Up',
      'On the Way',
      'Delivered',
      'Canceled'
    ];
    _tag = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order List',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
      body: Column(
        children: [
          ChipsChoice<int>.single(
            value: _tag,
            onChanged: (val) {
              setState(() {
                _tag = val;
              });
            },
            choiceItems: C2Choice.listFrom<int, String>(
              source: _options,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.orders.snapshots(),
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
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No orders found'),
                  );
                }
                final orders = snapshot.data!.docs.where((order) {
                  if (_tag == 0) {
                    return true;
                  } else {
                    return order['orderStatus'] == _options[_tag];
                  }
                }).toList();
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text(order['timestamp'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order['seller']['shopName'] ?? ''),
                          Text('Buyer ID: ${order['userId']}'),
                        ],
                      ),
                      trailing: Text(order['orderStatus'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
