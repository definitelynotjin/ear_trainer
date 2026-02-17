import 'package:flutter/material.dart';

class Interval extends StatelessWidget {
  const Interval({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interval',
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
