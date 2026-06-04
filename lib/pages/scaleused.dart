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
        title: Text(
          'Scale Used123',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
      ),
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              'C Major Scale',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: Note.notes.length,
                itemBuilder: (context, index) {
                  final note = Note.notes[index];
                  return ScaleUsedButton(
                    noteName: note.name,
                    circleIcon: 'assets/icons/waves.svg',
                    soundAsset: 'assets/audio/${note.name}${note.octave}.wav',
                    onPressed: () => _play(note),
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
