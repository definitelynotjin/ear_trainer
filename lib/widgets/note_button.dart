import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleNoteButton extends StatelessWidget {
  final String circleIcon;
  final String
  soundAsset; // kept for semantics / debugging; parent plays the sound
  final VoidCallback onPressed;
  final double size;

  const CircleNoteButton({
    required this.circleIcon,
    required this.soundAsset,
    required this.onPressed,
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
            width: s,
            height: s,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/waves.svg',
                width: s * 0.8,
                height: s * 0.8,
                fit: BoxFit.contain,
                color: Colors.white60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
