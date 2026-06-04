import 'package:flutter/material.dart';

class Scale extends StatelessWidget {
  const Scale({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Scale',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
      ),
      body: Column(children: [Text('tests')]),
    );
  }
}
