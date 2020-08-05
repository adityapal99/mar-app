import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mar_app/api/models.dart';
import 'dart:async';

import 'package:mar_app/widgets/small.dart';

class StudentHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudentHomeState();
}

class StudentHomeState extends State<StudentHome> {
  final String url = 'http://192.168.31.188:7869/api/';
  final FlutterSecureStorage storage = FlutterSecureStorage();
  var ActivePage = (student) {
    return StudentStartingPage(
      student: student,
    );
  };

  bool _loading = false;
  Student student;

  Future<Student> getData() async {
    String apiToken = await storage.read(key: 'token');

    var jsonData = await getJsonData(apiToken);

    setState(() {
      this.student = Student.fromJsonData(jsonData);
    });
    return this.student;
  }

  Future<dynamic> getJsonData(String apiToken) async {
    Map<String, String> headers = {'Authorization': 'Token $apiToken'};

    try {
      var response = await get('${this.url}student', headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Invalid Token");
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
  void dispose() {
    this.student = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Home"),
              selected: true,
              onTap: () {},
            ),
            ListTile(
              title: Text("Dashboard"),
              selected: true,
              onTap: () {},
            ),
            ListTile(
              title: Text("Your Data"),
              selected: true,
              onTap: () {},
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        initialData: Text("Innitial Data"),
        future: this.getData(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasData) {
              return Center(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text('Home'),
                        actions: <Widget>[],
                      ),
                    ];
                  },
                  body: Center(
                    child: ActivePage(student),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else {
              return Container(
                child: loading_popup(context),
              );
            }
          } on Exception catch (e) {
            return loading_popup(context);
          }
        },
      ),
    );
  }
}

class StudentStartingPage extends StatefulWidget {
  Student student;

  StudentStartingPage({this.student});

  @override
  State<StatefulWidget> createState() => StudentSPState(this.student);
}

class StudentSPState extends State<StudentStartingPage> {
  Student student;

  StudentSPState(this.student);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text("${student.name}"),
    );
  }
}
