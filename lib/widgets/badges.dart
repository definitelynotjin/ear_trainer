import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Badges extends StatelessWidget {
  final String circleIcon;
  final String badgeName;
  final VoidCallback onPressed;
  final double size;

  const Badges({
    required this.circleIcon,
    required this.onPressed,
    required this.badgeName,
    this.size = 120,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double s = size;
    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(s / 2),
          onTap: onPressed,
          child: SizedBox(
            width: s,
            height: s,
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
                  badgeName,
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
    );
  }
}
