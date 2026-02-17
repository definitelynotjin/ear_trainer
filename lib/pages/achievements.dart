import 'package:flutter/material.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
