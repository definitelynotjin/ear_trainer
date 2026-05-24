import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ABOUT ME RAWR',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [],
        backgroundColor: Colors.red,
      ),
      body: Column(),
    );
  }
}
