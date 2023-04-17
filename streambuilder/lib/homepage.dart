import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  StreamController<int> counterController = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: counterController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                );
              } else {
                return Text(
                  '0',
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          counterController.sink.add(counter);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
