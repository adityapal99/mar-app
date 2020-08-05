import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mar_app/forms/loginPage.dart';
import 'package:mar_app/pages/student_dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    if (FlutterSecureStorage().read(key: 'token') != null) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? StudentHome()
        : Scaffold(
            body: Container(
              child: LoginContainer(),
            ),
          );
  }
}
