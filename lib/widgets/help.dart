import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Help extends StatefulWidget {
  final String helpIcon;
  final String title;
  final String content;

  final double size;

  const Help({
    required this.helpIcon,
    required this.title,
    required this.content,
    this.size = 120,
    super.key,
  });

  @override
  State<Help> createState() => HelpButtonState();
}

class HelpButtonState extends State<Help> {
  void _showHelpModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: const Color.fromARGB(255, 42, 42, 42),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            widget.content,
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Got it!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double s = widget.size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(s / 8),
        onTap: _showHelpModal,
        child: SizedBox(
          width: s,
          height: s,
          child: Center(
            child: SvgPicture.asset(
              widget.helpIcon,
              width: s * 2,
              height: s * 2,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
