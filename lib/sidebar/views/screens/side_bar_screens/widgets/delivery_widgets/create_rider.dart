import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateNewDeliveryRider extends StatefulWidget {
  const CreateNewDeliveryRider({super.key});

  @override
  State<CreateNewDeliveryRider> createState() => _CreateNewDeliveryRiderState();
}

class _CreateNewDeliveryRiderState extends State<CreateNewDeliveryRider> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  var emailText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: GlobalStyles.screenWidth(context),
        child: Column(
          children: [
            Visibility(
              visible: _visible ? false : true,
              child: Container(
                width: GlobalStyles.screenWidth(context) - 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _visible = true;
                    });
                  },
                  child: const Text(
                    'Add New Delivery Rider',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _visible,
              child: Container(
                width: GlobalStyles.screenWidth(context),
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 400,
                          child: TextField(
                            controller: emailText,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              hintText: 'Enter the new Request Email',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                        ),
                        onPressed: () async {
                          if (emailText.text.isEmpty) {
                            await _services.showMyDialog(
                              context: context,
                              title: 'Email Id',
                              message: "Email can't be empty",
                            );
                          }

                          EasyLoading.show();
                          _services
                              .saveDeliveryRider(emailText.text, 'rider')
                              .whenComplete(() {
                            emailText.clear();

                            EasyLoading.dismiss();
                            _services.showMyDialog(
                                context: context,
                                title: 'Saved',
                                message: 'Delivery Rider Saved Successfully');
                          });
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
