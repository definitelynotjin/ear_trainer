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
    return Padding(
      padding: EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 40, height: 40),
            const SizedBox(width: 20),
            Text(label, style: TextStyle(color: Colors.red, fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
