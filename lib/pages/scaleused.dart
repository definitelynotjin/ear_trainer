import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScaleUsed extends StatefulWidget {
  const ScaleUsed({super.key});

  @override
  State<ScaleUsed> createState() => _ScaleUsedState();
}

class _ScaleUsedState extends State<ScaleUsed> {
  static const _accent = Color(0xFF6C5CE7);
  final AudioPlayer _player = AudioPlayer();
  int _playingIndex = -1;

  Future<void> _play(Note note, int index) async {
    await _player.stop();
    final asset = 'audio/${note.name}${note.octave}.wav';
    await _player.play(AssetSource(asset));
    setState(() => _playingIndex = index);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _playingIndex = -1);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Note.notes;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F3460),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Scale Reference',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  children: [
                    const Text(
                      'C Major Scale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ascending',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Starts at C4, ends at C5 — tap to hear each note',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withValues(alpha: 0.2),
                          size: 16,
                        ),
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isPlaying = _playingIndex == index;
                      final isFirst = index == 0;
                      final isLast = index == notes.length - 1;
                      return GestureDetector(
                        onTap: () => _play(note, index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? _accent.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isFirst || isLast
                                  ? _accent.withValues(alpha: 0.5)
                                  : (isPlaying
                                        ? _accent
                                        : Colors.white.withValues(alpha: 0.15)),
                              width: isFirst || isLast ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: _accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/waves.svg',
                                    width: 20,
                                    height: 20,
                                    color: isPlaying ? _accent : Colors.white60,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${note.name}${note.octave}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${note.frequency.toStringAsFixed(1)} Hz',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isFirst)
                                _Tag(label: 'START', color: _accent)
                              else if (isLast)
                                _Tag(label: 'END', color: _accent),
                            ],
                          ),
                        ),
                      );
                    },
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

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
