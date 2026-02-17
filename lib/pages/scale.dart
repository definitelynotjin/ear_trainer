import 'package:flutter/material.dart';

class Scale extends StatelessWidget {
  const Scale({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scale',
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
