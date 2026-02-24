import 'package:ear_trainer/widgets/menu_button.dart';
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
              Color.fromARGB(255, 105, 14, 174),
              Color.fromARGB(255, 8, 175, 161),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Text(
                  'Ear Trainer',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 150),
                MenuButton(
                  label: 'Pitch',
                  iconPath: 'assets/icons/single_note.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Pitch()),
                    );
                  },
                ),
                SizedBox(height: 1),
                MenuButton(
                  label: 'Interval',
                  iconPath: 'assets/icons/double_note.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const interval_page.Interval(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 1),
                MenuButton(
                  label: 'Scale',
                  iconPath: 'assets/icons/piano.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Scale()),
                    );
                  },
                ),
                SizedBox(height: 1),
                MenuButton(
                  label: 'Achievements',
                  iconPath: 'assets/icons/trophy.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Achievements(),
                      ),
                    );
                  },
                ),
                Text(
                  'rawr',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
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
