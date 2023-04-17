import 'dart:convert';
import 'package:flite3/usermodel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel userObject =
       UserModel(id: "email", fullname: "Ashish", email: " email@gmail.com");

  String userJson =
      ' {"id" : "0001", "fullname": "ashish Pandey","email": "email@gmail.com"}';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  //serializzation - convert it into json
                  Map<String, dynamic> userMap = userObject.toMap();
                  var json = jsonEncode(userMap);
                  print(json.toString());
                },
                child: Text("Serialize")),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  var decoded = jsonDecode(userJson);
                  Map<String, dynamic> userMap = decoded;
                  UserModel newUser = new UserModel.fromMap(userMap);
                  print(newUser.fullname.toString());
                },
                child: Text("De - serialize")),
          ],
        ),
      )),
    );
  }
}
