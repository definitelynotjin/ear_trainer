import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final bool unlocked;
  final VoidCallback onPressed;
  static const String _lockedIcon = 'assets/icons/locked.svg';

  const AchievementBadge({
    super.key,
    required this.description,
    required this.title,
    required this.icon,
    this.unlocked = false,
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
            color: unlocked ? Colors.white10 : Colors.black26,
            border: Border.all(
              color: unlocked ? Colors.tealAccent : Colors.white24,
              width: unlocked ? 1.0 : 0.7,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: SvgPicture.asset(
                  unlocked ? icon : _lockedIcon,
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
                  colorFilter: ColorFilter.mode(
                    unlocked ? Colors.white : Colors.white38,
                    BlendMode.srcIn,
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: unlocked ? Colors.white : Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: unlocked ? Colors.white70 : Colors.white38,
                        fontSize: 10,
                      ),
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
