import 'package:admin_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    Future<void> _deleteCategory(String documentId) async {
      await _services.categories.doc(documentId).delete();
    }

    Future<void> _showDeleteConfirmationDialog(
        BuildContext context, String documentId) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Category'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are You Sure You Want to Delete this Category?',
                  ),
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
                  _deleteCategory(documentId);
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
      stream: _services.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        List<Widget> categoryWidgets = snapshot.data!.docs.map(
          (DocumentSnapshot document) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 0),
                      color: Colors.green,
                    ),
                  ]),
              margin: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                (document.data()
                                    as Map<String, dynamic>)['image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            document['categoryName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, document.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList();
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Display categories in a grid layout with 5 columns for larger screens
              return Container(
                height: 900,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: categoryWidgets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return categoryWidgets[index];
                  },
                ),
              );
            } else {
              // Display categories in a column layout for smaller screens
              return SingleChildScrollView(
                child: Column(
                  children: categoryWidgets,
                ),
              );
            }
          },
        );
      },
    );
  }
}
