import 'package:ear_trainer/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/pages/pitch.dart';
import 'package:ear_trainer/pages/interval.dart' as interval_page;
import 'package:ear_trainer/pages/scale.dart';
import 'package:ear_trainer/pages/achievements.dart';
import 'package:ear_trainer/pages/scaleused.dart';
import 'package:ear_trainer/pages/splash.dart';
import 'package:ear_trainer/pages/statistics.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:ear_trainer/widgets/app_background.dart';
import 'package:ear_trainer/widgets/feedback_popup.dart';
import 'package:ear_trainer/widgets/haptics.dart';
import 'package:flutter_svg/flutter_svg.dart';

const bool _enableAdminFab = bool.fromEnvironment(
  'ENABLE_ADMIN_FAB',
  defaultValue: false,
);

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  void initState() {
    super.initState();
    QuizSession().load();
  }

  int _progressFor(String key) => QuizSession().getQuestion(key);
  bool _lifetimeCompleted(String key, int threshold) =>
      QuizSession().getLifetime(key) >= threshold;

  bool get _intervalUnlocked =>
      _lifetimeCompleted('pitch', 10) ||
      QuizSession().getQuestion('pitch') >= 10;
  bool get _scaleUnlocked =>
      _lifetimeCompleted('interval', 5) ||
      QuizSession().getQuestion('interval') >= 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F3460),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showSettingsSheet(context);
          if (mounted) setState(() {});
        },
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ear_trainer.svg',
                      width: 60,
                      height: 60,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ear Trainer',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Train your musical ear',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    children: [
                      _GridCard(
                        label: 'Pitch',
                        iconPath: 'assets/icons/single_note.svg',
                        accentColor: const Color(0xFFFF6B35),
                        subtitle: 'Higher or lower?',
                        progress: _progressFor('pitch'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Pitch()),
                        ).then((_) => setState(() {})),
                      ),
                      _GridCard(
                        label: 'Interval',
                        iconPath: 'assets/icons/double_note.svg',
                        accentColor: const Color(0xFF00B8A9),
                        subtitle: _intervalUnlocked
                            ? 'Distance between notes'
                            : 'Complete 10 Pitch',
                        progress: _progressFor('interval'),
                        locked: !_intervalUnlocked,
                        onTap: _intervalUnlocked
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const interval_page.Interval(),
                                ),
                              ).then((_) => setState(() {}))
                            : () => FeedbackPopup.info(
                                context,
                                title: 'Complete 10 Pitch questions first',
                              ),
                      ),
                      _GridCard(
                        label: 'Scale',
                        iconPath: 'assets/icons/waves.svg',
                        accentColor: const Color(0xFFF8B400),
                        subtitle: _scaleUnlocked
                            ? 'Find missing note'
                            : 'Complete 5 Interval',
                        progress: _progressFor('scale'),
                        locked: !_scaleUnlocked,
                        onTap: _scaleUnlocked
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Scale(),
                                ),
                              ).then((_) => setState(() {}))
                            : () => FeedbackPopup.info(
                                context,
                                title: 'Complete 5 Interval questions first',
                              ),
                      ),
                      _GridCard(
                        label: 'Achievements',
                        iconPath: 'assets/icons/trophy.svg',
                        accentColor: const Color(0xFFB983FF),
                        subtitle: 'Your badges',
                        progress: Achievement.all
                            .where((a) => a.isUnlocked)
                            .length,
                        totalSteps: Achievement.all.length,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Achievements(),
                          ),
                        ).then((_) => setState(() {})),
                      ),
                      _GridCard(
                        label: 'Statistics',
                        iconPath: 'assets/icons/progress.svg',
                        accentColor: const Color(0xFF00B8A9),
                        subtitle: 'View your progress',
                        showProgress: false,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StatisticsPage(),
                          ),
                        ),
                      ),
                      _GridCard(
                        label: 'Scale Used',
                        iconPath: 'assets/icons/cadence.svg',
                        accentColor: const Color(0xFF6C5CE7),
                        subtitle: 'Reference scale',
                        showProgress: false,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScaleUsed()),
                        ),
                      ),
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

  Future<void> _showSettingsSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Factory Reset — available to all users
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final shouldReset = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1A1A2E),
                        title: const Text(
                          'Factory Reset?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'This will erase ALL data: progress, achievements, statistics, and history. This cannot be undone.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text(
                              'Reset Everything',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldReset == true) {
                    await Achievement.resetAll();
                    await QuizSession().resetAll();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text('Factory Reset'),
              ),
              // Admin-only buttons
              if (_enableAdminFab) ...[
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B8A9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final shouldUnlock = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF1A1A2E),
                          title: const Text(
                            'Unlock all achievements?',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'This will unlock every available achievement.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('Unlock'),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldUnlock == true) {
                      await Achievement.unlockAll();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Unlock All Achievements'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    QuizSession().setQuestion('pitch', 10);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Unlock Interval'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B8A9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    QuizSession().setQuestion('interval', 5);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Unlock Scale'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF1A1A2E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final s = QuizSession();
                    s.fillLifetime('pitch', 10);
                    s.fillLifetime('interval', 5);
                    s.fillLifetime('scale', 5);
                    Navigator.pop(context);
                    if (context.mounted) {
                      await Achievement.checkThankYou();
                      if (context.mounted)
                        await FeedbackPopup.thankYou(context);
                    }
                  },
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text('Test Thank You'),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _GridCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color accentColor;
  final String subtitle;
  final int progress;
  final int totalSteps;
  final bool locked;
  final bool showProgress;
  final VoidCallback onTap;

  const _GridCard({
    required this.label,
    required this.iconPath,
    required this.accentColor,
    required this.subtitle,
    this.progress = 0,
    this.totalSteps = 10,
    this.locked = false,
    this.showProgress = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptics.tap();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: locked ? 0.03 : 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withValues(alpha: locked ? 0.15 : 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: locked ? 0.08 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: locked
                    ? Icon(
                        Icons.lock_outline,
                        color: accentColor.withValues(alpha: 0.6),
                        size: 32,
                      )
                    : SvgPicture.asset(
                        iconPath,
                        width: 32,
                        height: 32,
                        color: accentColor,
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: locked
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: locked
                      ? accentColor.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              if (!locked && showProgress) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalSteps, (i) {
                    final filled = i < progress;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? Colors.white54
                            : Colors.white.withValues(alpha: 0.15),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WideCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color accentColor;
  final VoidCallback onTap;

  const _WideCard({
    required this.label,
    required this.iconPath,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
