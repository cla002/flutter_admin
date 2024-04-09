// ignore_for_file: unused_field

import 'package:admin_app/globals/styles.dart';
import 'package:admin_app/services/firebase_services.dart';
import 'package:admin_app/sidebar/views/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences package

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  static const String id = 'home-page';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late String username;
  late String password;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    autoLogin(); // Check for auto-login on app start
  }

  // Check for auto-login using shared preferences
  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    if (userToken != null) {
      // Token exists, automatically log the user in
      // Redirect to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            userRole: '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initialization = Firebase.initializeApp();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Once complete, show application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'L',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 50,
                                ),
                              ),
                              Image.asset(
                                'lib/images/logo.png',
                                height: 45,
                              ),
                              const Text(
                                'GIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 50,
                                ),
                              )
                            ],
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Your Username';
                              }
                              setState(() {
                                username = value;
                              });
                              if (value != username) {
                                return 'Invalid username';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Username',
                              hintText: 'Username',
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                              setState(() {
                                password = value;
                              });
                              if (value != password) {
                                return 'Invalid password';
                              }

                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Password',
                              helperText: 'Atleast 6 characters',
                              icon: Icon(Icons.vpn_key),
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                          FilledButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                Size(GlobalStyles.screenWidth(context), 40),
                              ),
                              shape: MaterialStateProperty.all(
                                const BeveledRectangleBorder(
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              EasyLoading.show();
                              if (_formKey.currentState!.validate()) {
                                bool found = false;
                                _services.getAdminCredentials().then((value) {
                                  value.docs.forEach((doc) {
                                    String dbUsername = doc.get('username');
                                    String dbPassword = doc.get('password');
                                    String role = doc.get(
                                        'role'); // Assuming role is stored in Firestore

                                    if (dbUsername == username &&
                                        dbPassword == password) {
                                      found = true;
                                      print('User found!');
                                      // Store the user's authentication token
                                      storeUserToken();
                                      // Navigate to MainScreen only if the user is found
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(
                                            userRole:
                                                role, // Pass the role to the MainScreen
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                  // Show error message if user is not found
                                  if (!found) {
                                    EasyLoading.dismiss();
                                    _showMyDialog(
                                      title: 'Invalid Credentials',
                                      message:
                                          'Please enter valid username and password.',
                                    );
                                  }
                                }).catchError((error) {
                                  EasyLoading.dismiss();
                                  print(
                                      'Error retrieving credentials: $error'); // Print the error message for debugging
                                  _showMyDialog(
                                    title: 'Error',
                                    message:
                                        'An error occurred. Please try again later.',
                                  );
                                }).whenComplete(() {
                                  EasyLoading.dismiss();
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          // Otherwise, show indicator while waiting for initialization to complete.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // Store the user's authentication token using shared preferences
  Future<void> storeUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Store the user's token in shared preferences
    await prefs.setString('userToken', 'token_here');
  }

  Future<void> _showMyDialog({title, message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                const Text('Please Try Again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
