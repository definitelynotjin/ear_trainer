import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  final String label;

  const Appbar({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(12));
  }
}
