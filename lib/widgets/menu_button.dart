import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
      onPressed: () {},
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
            SvgPicture.asset(
              iconPath,
              width: 25,
              height: 25,
              color: Colors.lightGreen,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
