import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final VoidCallback onPressed;

  const AchievementBadge({
    super.key,
    required this.description,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // show svg if available; otherwise show a fallback icon to avoid crashing
              SizedBox(
                width: 60,
                height: 60,
                child: SvgPicture.asset(
                  icon,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const Center(
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white54,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
