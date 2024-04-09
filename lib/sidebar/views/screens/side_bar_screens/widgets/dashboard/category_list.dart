import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NumberOfCategories extends StatefulWidget {
  const NumberOfCategories({Key? key}) : super(key: key);

  @override
  State<NumberOfCategories> createState() => _NumberOfCategoriesState();
}

class _NumberOfCategoriesState extends State<NumberOfCategories> {
  Future<List<Map<String, dynamic>>> _getCategoryInfo() async {
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    List<Map<String, dynamic>> categoryInfoList = [];
    for (var categoryDoc in categorySnapshot.docs) {
      String categoryName = categoryDoc['categoryName'];
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .get();
      int numberOfProducts = productsSnapshot.docs.length;
      categoryInfoList.add({
        'categoryName': categoryName,
        'numberOfProducts': numberOfProducts,
      });
    }
    return categoryInfoList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getCategoryInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Platform Products',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: snapshot.data!.map((categoryInfo) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    categoryInfo['categoryName'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    'Number of Products: -----  ${categoryInfo['numberOfProducts']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
