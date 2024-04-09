import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    Future<void> _deleteBanner(String documentId) async {
      await _services.banners.doc(documentId).delete();
    }

    Future<void> _showDeleteConfirmationDialog(
        BuildContext context, String documentId) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Banner'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this banner?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteBanner(documentId);
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _services.banners.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        return Container(
          width: GlobalStyles.screenWidth(context),
          height: 400,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                // Retrieve the image URL from the document data
                String imageUrl =
                    (document.data() as Map<String, dynamic>)['image'] ?? '';

                // Print the image URL for debugging
                print('Image URL: $imageUrl');

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 400,
                          child: Card(
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                imageUrl,
                                width: 600,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  // Display a placeholder image or an error message when the image fails to load
                                  return Container(
                                    color: Colors.grey,
                                    width: 600,
                                    height: 400,
                                    child: const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, document.id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
