import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/widgets/haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SweetAlert-style center popup feedback.
/// Shows an icon + title in a rounded card overlay, auto-dismisses after [duration].
/// Plays a sound effect when [soundAsset] is provided.
class FeedbackPopup {
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  /// Show a success popup (green check) + correct sound.
  static Future<void> success(
    BuildContext context, {
    String title = 'Correct',
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    Haptics.correct();
    _playSound('audio/correct.wav');
    return _show(
      context,
      title: title,
      icon: Icons.check_circle,
      color: Colors.green,
      duration: duration,
    );
  }

  /// Show an error popup (red cross) + incorrect sound.
  static Future<void> error(
    BuildContext context, {
    String title = 'Incorrect',
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    Haptics.wrong();
    _playSound('audio/incorrect.wav');
    return _show(
      context,
      title: title,
      icon: Icons.cancel,
      color: Colors.red,
      duration: duration,
    );
  }

  /// Show an info popup (blue info) + misc sound.
  static Future<void> info(
    BuildContext context, {
    required String title,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    Haptics.tap();
    _playSound('audio/misc.wav');
    return _show(
      context,
      title: title,
      icon: Icons.info,
      color: Colors.blue,
      duration: duration,
    );
  }

  /// Show an achievement unlocked popup with custom title.
  static Future<void> achievement(
    BuildContext context, {
    required String title,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return _show(
      context,
      title: title,
      icon: Icons.emoji_events,
      color: Colors.amber,
      duration: duration,
    );
  }

  /// Thank-you modal — must tap "You're Welcome" to close.
  static Future<void> thankYou(BuildContext context) async {
    Haptics.achievement();
    _playSound('audio/correct.wav');
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFFD700), width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/badges/badge_thank_you.svg',
              width: 72,
              height: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank you for your input and may your ear grow ever sharper. '
              'Keep listening, keep learning, and keep living. '
              'I truly appreciate you being part of this journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1A1A2E),
              backgroundColor: const Color(0xFFFFD700),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "You're Welcome",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  static void _playSound(String asset) {
    _sfxPlayer.stop();
    _sfxPlayer.play(AssetSource(asset));
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Duration duration,
  }) async {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _PopupView(title: title, icon: icon, color: color),
    );
    overlay.insert(entry);
    await Future.delayed(duration);
    entry.remove();
  }
}

class _PopupView extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PopupView({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<_PopupView> createState() => _PopupViewState();
}

class _PopupViewState extends State<_PopupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 32, 32),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.color, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: widget.color, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
