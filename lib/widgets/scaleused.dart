import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScaleUsedButton extends StatelessWidget {
  final String circleIcon;
  final String
  soundAsset; // kept for semantics / debugging; parent plays the sound
  final String noteName;
  final VoidCallback onPressed;
  final double size;

  const ScaleUsedButton({
    required this.circleIcon,
    required this.soundAsset,
    required this.onPressed,
    required this.noteName,
    this.size = 120,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double s = size;
    return Semantics(
      label: soundAsset,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(s / 2),
          onTap: onPressed,
          child: SizedBox(
            width: s * 0.5,
            height: s * 0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/waves.svg',
                    width: s * 0.8,
                    height: s * 0.8,
                    fit: BoxFit.contain,
                    color: Colors.white60,
                  ),
                  Text(
                    noteName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
