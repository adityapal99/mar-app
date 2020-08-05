import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mar_app/api/connect.dart';
import 'package:http/http.dart' as http;
import 'package:mar_app/pages/student_dashboard.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mar_app/widgets/small.dart';

class TopShapeCliper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, -size.height, size.width, size.height);
  }

  @override
  bool shouldReclip(TopShapeCliper oldClipper) {
    return false;
  }
}

class LoginContainer extends StatefulWidget {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return LoginContainerState(
        emailController: emailController, passwordController: passwordController);
  }
}

class LoginContainerState extends State<LoginContainer> {
  final String url = 'http://192.168.31.188:7869/api/';

  bool _isLoading = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  LoginContainerState({this.emailController, this.passwordController});

  Future<String> _login() async {
    try {
      var token = await this
          .fromUsernamePassword(email: emailController.text, password: passwordController.text);
      var storage = FlutterSecureStorage();
      print(token);
      if (token != null) {
        storage.write(key: 'token', value: token);
      }
      return token;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<dynamic> fromUsernamePassword({String email, String password}) async {
    Map<String, String> payload = {'username': email, 'password': password};

    try {
      var response = await http.post('${this.url}auth/', body: payload, headers: {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        return responseJson['token'];
      } else if (response.statusCode == 400) {
        throw Exception("Incorrect Email/Password");
      } else
        throw Exception('Authentication Error');
    } on SocketException catch (exception) {
      if (exception == null || exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else {
        return null;
      }
    } on Exception catch (exception) {
      throw exception;
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(children: <Widget>[
        Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                child: Stack(children: <Widget>[
                  // ClipOval(
                  //   clipper: TopShapeCliper(),
                  //   clipBehavior: Clip.antiAlias,
                  //   child: Container(
                  //     child: Align(
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //               colors: <Color>[Colors.green[200], Colors.green[400]],
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight),
                  //         ),
                  //         height: MediaQuery.of(context).size.height / 2.2,
                  //         width: MediaQuery.of(context).size.width,
                  //         alignment: Alignment.bottomCenter,
                  //         child: Container(
                  //           margin: EdgeInsets.only(bottom: 20),
                  //           padding: EdgeInsets.all(20),
                  //           child: Text(
                  //             "Login",
                  //             style: TextStyle(
                  //               fontSize: 42,
                  //               fontWeight: FontWeight.w900,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ClipOval(
                    clipper: TopShapeCliper(),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      child: Align(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[Colors.orange[200], Colors.orange[400]],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          height: MediaQuery.of(context).size.height / 3.3,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  ClipOval(
                    clipper: TopShapeCliper(),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      child: Align(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[Colors.blue[200], Colors.lightBlue[400]],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height / 3 - 10,
                    child: Container(
                      decoration: ShapeDecoration(shape: CircleBorder(), shadows: [
                        BoxShadow(blurRadius: 10, color: Colors.black26, offset: Offset(0, 10))
                      ]),
                      child: Image.network(
                        "https://jiscollege.ac.in/JISTech2K19/JISCELogo.png",
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
          Center(
            child: Form(
                autovalidate: true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: emailController,
                          cursorWidth: 1,
                          autovalidate: true,
                          validator: (string) {
                            if (string.contains("@") && string.contains(".")) {
                              return null;
                            }
                            if (string.isEmpty) {
                              return null;
                            } else {
                              return "Invalid Email";
                            }
                          },
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                              alignLabelWithHint: true,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                              fillColor: Colors.white,
                              hoverColor: Colors.grey[50]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: passwordController,
                          autovalidate: true,
                          cursorWidth: 1,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.security),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                              fillColor: Colors.white,
                              hoverColor: Colors.grey[50]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              var apiKey = await this._login();
                              if (apiKey != null) {
                                print(apiKey);
                              }
                            } on Exception catch (e) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(e.toString().replaceFirst("Exception: ", ""))));
                            }
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return StudentHome();
                              },
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    colors: <Color>[Colors.blue[200], Colors.blue[400]])),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ]),
        _isLoading ? loading_popup(context) : Container(),
      ]),
    );
  }
}
