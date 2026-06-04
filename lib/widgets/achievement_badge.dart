import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const AchievementBadge({
    super.key,
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
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
