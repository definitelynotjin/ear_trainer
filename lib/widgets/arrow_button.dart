import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArrowButton extends StatefulWidget {
  final String arrowIcon;
  final VoidCallback onPressed;
  final double size;

  const ArrowButton({
    required this.arrowIcon,
    required this.onPressed,
    this.size = 120,
    super.key,
  });

  @override
  State<ArrowButton> createState() => ArrowButtonState();
}

class ArrowButtonState extends State<ArrowButton> {
  @override
  Widget build(BuildContext context) {
    final double s = widget.size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(s / 8),
        onTap: widget.onPressed,
        child: SizedBox(
          width: s,
          height: s,
          child: Center(
            child: SvgPicture.asset(
              widget.arrowIcon,
              width: s * 4,
              height: s * 4,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
