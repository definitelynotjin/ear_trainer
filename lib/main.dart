import 'package:ear_trainer/pages/frontpage.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Achievement.loadState();
  await QuizSession().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const FrontPage(),
    );
  }
}
