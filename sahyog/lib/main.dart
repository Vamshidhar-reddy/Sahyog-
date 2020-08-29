import 'package:flutter/material.dart';
import 'package:sahyog/listview.dart';

//Custom widgets

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahyog',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
              child: Text(
            'SAHYOG Developer',
            style: TextStyle(backgroundColor: Colors.green),
          )),
        ),
        body: Center(
          child: Home(),
        ),
      ),
    );
  }
}
