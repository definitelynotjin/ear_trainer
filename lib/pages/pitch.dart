import 'package:flutter/material.dart';

class Pitch extends StatelessWidget {
  const Pitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pitch',
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
