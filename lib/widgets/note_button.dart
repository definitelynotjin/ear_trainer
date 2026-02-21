import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleNoteButton extends StatefulWidget {
  final String circleIcon;
  final String soundAsset;
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
  State<CircleNoteButton> createState() => CircleNoteButtonState();
}

class CircleNoteButtonState extends State<CircleNoteButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {},
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Center(child: SvgPicture.asset('assets/icons/circle.svg')),
      ),
    );
  }
}
