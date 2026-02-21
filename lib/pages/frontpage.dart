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
      appBar: AppBar(
        title: Text(
          'Ear Trainer',
          style: TextStyle(color: Colors.yellow, fontSize: 51),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: 260,
      ),
      backgroundColor: Colors.cyan,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          MenuButton(
            label: 'Achievements',
            iconPath: 'assets/icons/trophy.svg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Achievements()),
              );
            },
          ),
        ],
      ),
    );
  }
}
