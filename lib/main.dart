import 'package:ear_trainer/pages/frontpage.dart';
import 'package:ear_trainer/pages/splash.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Achievement.loadState();
  await QuizSession().load();
  final isFirstLaunch = await QuizSession().isFirstVisit('app_intro');
  runApp(MyApp(showSplash: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool showSplash;
  const MyApp({super.key, this.showSplash = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: _Root(showSplash: showSplash),
    );
  }
}

class _Root extends StatefulWidget {
  final bool showSplash;
  const _Root({this.showSplash = false});

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  bool _showSplash = false;

  @override
  void initState() {
    super.initState();
    _showSplash = widget.showSplash;
  }

  void _finishSplash() {
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen(onDone: _finishSplash)
        : const FrontPage();
  }
}
