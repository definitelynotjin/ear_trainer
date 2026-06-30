import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/widgets/scaleused.dart';

class ScaleUsed extends StatefulWidget {
  const ScaleUsed({super.key});

  @override
  State<ScaleUsed> createState() => _ScaleUsedState();
}

class _ScaleUsedState extends State<ScaleUsed> {
  final AudioPlayer _player = AudioPlayer();
  late Note note;

  Future<void> _play(Note note) async {
    await _player.stop();
    final asset = 'audio/${note.name}${note.octave}.wav';
    await _player.play(AssetSource(asset));
    setState(() {});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Scale Used',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.all(
          20,
        ), // Left and right "walls" are defined here
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'C Major Scale',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              // LayoutBuilder looks at the actual layout constraints of the phone screen
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double buttonSize = 75.0;
                  final int totalNotes = Note.notes.length;

                  // Calculate exactly how much horizontal room we have to move the button
                  final double maxAvailableWidth =
                      constraints.maxWidth - buttonSize;

                  // Divide that width evenly by the total intervals (8 notes means 7 gaps)
                  final double horizontalStep =
                      maxAvailableWidth / (totalNotes - 1);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(totalNotes, (index) {
                      final int reversedIndex = totalNotes - 1 - index;
                      final note = Note.notes[reversedIndex];

                      return Padding(
                        // Dynamic math:
                        // C4 (reversedIndex 0) -> left padding is 0.0 (Hugs Left Wall)
                        // C5 (reversedIndex 7) -> left padding is max available width (Hugs Right Wall)
                        padding: EdgeInsets.only(
                          left: reversedIndex * horizontalStep,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScaleUsedButton(
                            size: buttonSize,
                            noteName: '${note.name}${note.octave}',
                            circleIcon: 'assets/icons/waves.svg',
                            soundAsset:
                                'assets/audio/${note.name}${note.octave}.wav',
                            onPressed: () => _play(note),
                          ),
                        ),
                      );
                    }),
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
