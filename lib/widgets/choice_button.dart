import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String answer;
  final String? subtitle;
  final VoidCallback onPressed;

  const ChoiceButton({
    this.subtitle,
    required this.answer,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38),
              ),
            ],

            // const Text(
            //   'notes apart',
            //   style: TextStyle(fontSize: 12, color: Colors.white38),
            // ),
          ],
        ),
      ),
    );
  }
}
