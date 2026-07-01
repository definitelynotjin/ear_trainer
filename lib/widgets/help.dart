import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final AudioPlayer _miscPlayer = AudioPlayer();
void _playMisc() {
  _miscPlayer.stop();
  _miscPlayer.play(AssetSource('audio/misc.wav'));
}

class Help extends StatefulWidget {
  final String helpIcon;
  final String title;
  final String content;
  final String pageId;
  final double size;

  const Help({
    required this.helpIcon,
    required this.title,
    required this.content,
    required this.pageId,
    this.size = 120,
    super.key,
  });

  @override
  State<Help> createState() => HelpButtonState();
}

class HelpButtonState extends State<Help> {
  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final first = await QuizSession().isFirstVisit(widget.pageId);
    if (first && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showHelpModal());
    }
  }

  void _showHelpModal() {
    _playMisc();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.tealAccent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            widget.content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Got it',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double s = widget.size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(s / 8),
        onTap: _showHelpModal,
        child: SizedBox(
          width: s,
          height: s,
          child: Center(
            child: SvgPicture.asset(
              widget.helpIcon,
              width: s * 2,
              height: s * 2,
              fit: BoxFit.fill,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
