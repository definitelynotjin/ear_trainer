import 'package:ear_trainer/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/pages/pitch.dart';
import 'package:ear_trainer/pages/interval.dart' as interval_page;
import 'package:ear_trainer/pages/scale.dart';
import 'package:ear_trainer/pages/achievements.dart';
import 'package:ear_trainer/pages/scaleused.dart';
import 'package:ear_trainer/models/achievements.dart';

// Enable with: --dart-define=ENABLE_ADMIN_FAB=true
const bool _enableAdminFab = bool.fromEnvironment(
  'ENABLE_ADMIN_FAB',
  defaultValue: false,
);

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

                      const SizedBox(height: 12),

                      SizedBox(
                        child: MenuButton(
                          iconColor: Colors.orangeAccent,
                          label: 'Scale Used',
                          iconPath: 'assets/icons/cadence.svg',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScaleUsed(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      // SizedBox(
                      //   child: Center(
                      //     child: MenuButton(
                      //       label: 'About the App',
                      //       iconPath: 'assets/icons/cadence.svg',
                      //       onTap: () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => const AboutMe(),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (_enableAdminFab)
                        FloatingActionButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: const Color.fromARGB(
                                255,
                                32,
                                32,
                                32,
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final shouldReset =
                                              await showDialog<bool>(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                          255,
                                                          32,
                                                          32,
                                                          32,
                                                        ),
                                                    title: const Text(
                                                      'Reset achievements?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'This will clear all unlocked achievements and exercise progress.',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              dialogContext,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              dialogContext,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Reset',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                          if (shouldReset == true) {
                                            await Achievement.resetAll();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Achievements reset',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.restart_alt),
                                        label: const Text('Reset Achievements'),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final shouldUnlock =
                                              await showDialog<bool>(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                          255,
                                                          32,
                                                          32,
                                                          32,
                                                        ),
                                                    title: const Text(
                                                      'Unlock all achievements?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'This will unlock every available achievement.',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              dialogContext,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              dialogContext,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Unlock',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                          if (shouldUnlock == true) {
                                            await Achievement.unlockAll();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'All achievements unlocked',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.lock_open),
                                        label: const Text(
                                          'Unlock All Achievements',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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
}
