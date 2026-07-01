import 'package:ear_trainer/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onDone;
  const SplashScreen({super.key, this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      icon: 'assets/icons/ear_trainer.svg',
      iconColor: Color(0xFF00B8A9),
      title: 'Welcome to Ear Trainer',
      body:
          'Train your musical ear with three progressive exercises. '
          'Learn to identify pitch, intervals, and scales by sound alone.',
    ),
    _Slide(
      icon: 'assets/icons/single_note.svg',
      iconColor: Color(0xFFFF6B35),
      title: 'How It Works',
      body:
          '1. Tap the note buttons to hear sounds\n'
          '2. Compare what you hear\n'
          '3. Pick the right answer\n'
          '4. Unlock new exercises as you progress\n'
          '5. Earn achievements along the way',
    ),
    _Slide(
      icon: 'assets/icons/trophy.svg',
      iconColor: Color(0xFFB983FF),
      title: 'Progressive Unlock',
      body:
          'Start with Pitch — complete 10 questions to unlock Interval.\n'
          'Complete 5 Interval questions to unlock Scale.\n'
          'Each exercise has its own help guide — tap ? anytime.\n\n'
          'Ready? Let\'s train your ear.',
    ),
  ];

  void _finish() {
    if (widget.onDone != null) {
      widget.onDone!.call();
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3460),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) {
                    final s = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: s.iconColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              s.icon,
                              width: 64,
                              height: 64,
                              color: s.iconColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            s.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s.body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF00B8A9)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B8A9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _next,
                    child: Text(
                      _page < _slides.length - 1 ? 'Next' : 'Get Started',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide {
  final String icon;
  final Color iconColor;
  final String title;
  final String body;
  const _Slide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });
}
