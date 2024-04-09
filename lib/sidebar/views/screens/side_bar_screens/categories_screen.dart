import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\CategoriesScreen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;
  String? filename;
  late String categoryName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;

        // Get the filename of the image selected
        filename = result.files.first.name;
      });
    }
  }

  uploadCategory() async {
    if (_image != null && categoryName.isNotEmpty) {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        String imageUrl = await _uploadCategoryBannerToStorage(_image);
        await _firestore.collection('categories').doc(filename).set({
          'image': imageUrl,
          'categoryName': categoryName,
        }).whenComplete(() {
          EasyLoading.dismiss();
          setState(() {
            _image = null;
            _formKey.currentState!.reset();
          });
        });
      } else {
        EasyLoading.dismiss();
        print('Invalid Category');
      }
    } else {
      print('Category is not complete');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Incomplete Entry',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  _uploadCategoryBannerToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImages').child(filename!);

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Display content in row layout for larger screens
          return _buildRowLayout();
        } else {
          // Display content in column layout for smaller screens
          return _buildColumnLayout();
        }
      },
    );
  }

  Widget _buildRowLayout() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                horizontal: GlobalStyles.screenHeight(context) * 0.03,
                vertical: GlobalStyles.screenHeight(context) * 0.01,
              ),
              child: const Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.0,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            _buildImageAndButtons(),
            _buildCategoryForm(),
            const SizedBox(height: 50.0),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.0,
                ),
              ),
            ),
            const CategoryWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnLayout() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                horizontal: GlobalStyles.screenHeight(context) * 0.03,
                vertical: GlobalStyles.screenHeight(context) * 0.01,
              ),
              child: const Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.0,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            _buildImageAndButtons(),
            _buildCategoryForm(),
            const SizedBox(height: 50.0),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.0,
                ),
              ),
            ),
            const CategoryWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAndButtons() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: GlobalStyles.screenHeight(context) * 0.03,
            vertical: GlobalStyles.screenHeight(context) * 0.01,
          ),
          child: Column(
            children: [
              Container(
                height: GlobalStyles.screenHeight(context) * 0.2,
                width: GlobalStyles.screenHeight(context) * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? Image.memory(_image, fit: BoxFit.cover)
                    : const Center(
                        child: Text('Image'),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                _pickImage();
              },
              child: const Text('Select Image'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  uploadCategory();
                } else {
                  print('Validation failed. Please correct the errors.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryForm() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: GlobalStyles.screenHeight(context) * 0.03,
      ),
      child: Row(
        children: [
          SizedBox(
            width: GlobalStyles.screenWidth(context) * 0.3,
            child: TextFormField(
              onChanged: (value) {
                categoryName = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This Field Cannot be Empty!';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Enter Category Name',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
