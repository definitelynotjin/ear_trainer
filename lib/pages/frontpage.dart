import 'package:ear_trainer/widgets/menu_button.dart';
import 'package:ear_trainer/widgets/aboutme.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/pages/pitch.dart';
import 'package:ear_trainer/pages/interval.dart' as interval_page;
import 'package:ear_trainer/pages/scale.dart';
import 'package:ear_trainer/pages/achievements.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 208, 88, 88),
              Color.fromARGB(255, 112, 62, 151),
              Color.fromARGB(255, 64, 153, 145),
              // Color.fromARGB(255, 102, 192, 79),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                Text(
                  'Ear Trainer',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 120),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        child: MenuButton(
                          iconColor: Colors.redAccent,
                          label: 'Pitch',
                          iconPath: 'assets/icons/single_note.svg',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Pitch()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        child: MenuButton(
                          iconColor: Colors.cyanAccent,
                          label: 'Interval',
                          iconPath: 'assets/icons/double_note.svg',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const interval_page.Interval(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        child: MenuButton(
                          label: 'Scale',
                          iconColor: Colors.greenAccent,
                          iconPath: 'assets/icons/piano.svg',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Scale()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        child: MenuButton(
                          iconColor: Colors.purpleAccent,
                          label: 'Achievements',
                          iconPath: 'assets/icons/trophy.svg',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Achievements(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 160),
                      AboutMe(title: 'What about me nigga?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
