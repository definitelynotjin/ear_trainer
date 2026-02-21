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
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.brown)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 35, height: 35),
            const SizedBox(width: 20),
            Text(label, style: TextStyle(color: Colors.green, fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
