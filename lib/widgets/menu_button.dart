import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.label,
    required this.iconPath,
    this.iconColor = Colors.white,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          //   backgroundColor: Colors.black.withValues(alpha: 0.2),
          //   backgroundColor: Colors.transparent.withValues(alpha: 0.2),
          backgroundColor: Colors.black38.withValues(alpha: 0.2),
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                ),
                SvgPicture.asset(
                  iconPath,
                  width: 25,
                  height: 25,
                  color: iconColor,
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
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
