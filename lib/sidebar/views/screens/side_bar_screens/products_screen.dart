import 'package:admin_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = 'ProductScreen';

  Widget _rowHeader(String text, double flex) {
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

  Widget _rowData(
      BuildContext context, // Added context parameter
      String storeName,
      String productImage,
      String productName,
      String collection,
      String category,
      double price,
      int quantity,
      String documentId) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                documentId,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                storeName,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Image.network(
                productImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                productName,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                collection,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '₱$price',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, documentId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteProduct(BuildContext context, String documentId) async {
    FirebaseServices _services = FirebaseServices();
    try {
      await _services.products.doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting product')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteProduct(context, documentId); // Delete the product
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _services.products.snapshots(),
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
              child: Text('No products found'),
            );
          }
          return Column(
            children: [
              Row(
                children: [
                  _rowHeader('Product Id', 1),
                  _rowHeader('Store Name', 1),
                  _rowHeader('Image', 1),
                  _rowHeader('Product Name', 1),
                  _rowHeader('Collection', 1),
                  _rowHeader('Category', 1),
                  _rowHeader('Price', 1),
                  _rowHeader('Quantity', 1),
                ],
              ),
              const Divider(
                color: Colors.green,
                thickness: 2,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot product = snapshot.data!.docs[index];
                    return _rowData(
                      context, // Pass context here
                      product['seller.shopName'] ?? '',
                      product['productImage'] ?? '',
                      product['productName'] ?? '',
                      product['collection'] ?? '',
                      product['category'] ?? '',
                      (product['price'] ?? 0).toDouble(),
                      product['stockQuantity'] ?? 0,
                      product.id, // Pass documentId here
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
