import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';

class User {
  final String URL = 'http://192.168.31.188:7869/api/';
  String authtoken;
  Student student;

  User({String email, String password}) {
    this.fromEmailPasswrod(email: email, password: password);
  }

  User.fromAuthToken(this.authtoken) {
    void loadStudent() async {
      student = await _loadStudent();
    }

    loadStudent();
  }

  void fromEmailPasswrod({String email, String password}) async {
    authtoken = await _login(email, password);
    student = await _loadStudent();
  }

  Future<String> _login(String email, String password) async {
    Map<String, String> payload = {'username': email, 'password': password};
    var response = await http.post('${this.URL}auth/', body: payload, headers: {});
    var jsonData = json.decode(response.body);
    return jsonData['token'];
  }

  Future<Student> _loadStudent() async {
    var response =
        await http.get('${this.URL}student', headers: {'Authorization': 'Token ${this.authtoken}'});

    var jsonData = jsonDecode(response.body);

    return Future.delayed(
        Duration(seconds: 1),
        () => Student(
            name: jsonData['fname'],
            collegeID: jsonData['collegeID'],
            roll: jsonData['roll'],
            dept: jsonData['dept'],
            points: jsonData['points'],
            data: jsonData['student_data']));
  }

  Future<Student> getStudent() {
    return Future(() {
      while (true) {
        if (this.student != null) {
          return this.student;
        } else {
          continue;
        }
      }
    });
  }
}
