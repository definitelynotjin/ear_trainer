import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String answer;
  final String? subtitle;
  final VoidCallback onPressed;
  final bool highlighted;

  const ChoiceButton({
    this.subtitle,
    required this.answer,
    required this.onPressed,
    this.highlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: highlighted
              ? Colors.tealAccent.withOpacity(0.18)
              : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlighted ? Colors.tealAccent : Colors.white24,
            width: highlighted ? 0.8 : 0.5,
          ),
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
                style: TextStyle(
                  color: highlighted ? Colors.tealAccent : Colors.white38,
                  fontSize: 13,
                ),
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
