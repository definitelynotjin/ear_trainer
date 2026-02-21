import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:ear_trainer/widgets/note_button.dart';
import 'dart:math' as math;

class Pitch extends StatefulWidget {
  const Pitch({super.key});

  @override
  State<Pitch> createState() => _PitchState();
}

class _PitchState extends State<Pitch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pitch',
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
        actions: [],
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.cyan,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: StepProgressBar(
              totalSteps: 10,
              onStepChanged: (i) => debugPrint('step $i'),
            ),
          ),
          const Text(
            'Which note is higher?',
            style: TextStyle(fontSize: 25, color: Colors.brown),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/icons/circle.svg',
                width: 120,
                height: 120,
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                'assets/icons/circle.svg',
                width: 120,
                height: 120,
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    'assets/icons/arrow_left.svg',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(width: 10),

                  Transform.rotate(angle: -math.pi / 120),
                  SvgPicture.asset(
                    'assets/icons/arrow_right.svg',
                    height: 120,
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
