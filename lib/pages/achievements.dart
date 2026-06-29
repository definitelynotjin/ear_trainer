import 'package:ear_trainer/models/achievements.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/widgets/achievement_badge.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Achievements',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
      ),

      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // const SizedBox(height: 50),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: Achievement.all.length,
                itemBuilder: (context, index) {
                  final achievement = Achievement.all[index];
                  return AchievementBadge(
                    icon: achievement.icon,
                    title: achievement.title,
                    description: achievement.description,
                    unlocked: achievement.isUnlocked,
                    onPressed: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
