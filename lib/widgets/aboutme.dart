import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  final String title;
  const AboutMe({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsetsGeometry.all(2),
          child: Text(title, style: TextStyle(color: Colors.greenAccent)),
        ),
      ),
      onPressed: () {},
    );
  }
}
