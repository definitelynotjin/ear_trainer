import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuizNavigationButton extends StatefulWidget {
  final String navIcon;
  final String label;
  final VoidCallback onTap;
  final double size;

  const QuizNavigationButton({
    required this.navIcon,
    required this.label,
    required this.onTap,
    this.size = 120,
    super.key,
  });

  @override
  State<QuizNavigationButton> createState() => _QuizNavigationButtonState();
}

class _QuizNavigationButtonState extends State<QuizNavigationButton> {
  @override
  Widget build(BuildContext context) {
    final double s = widget.size;
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: widget.onTap,
        child: Row(
          children: [SvgPicture.asset(widget.navIcon, width: s, height: s)],
        ),
      ),
    );
  }
}
