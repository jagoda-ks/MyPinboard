import 'package:flutter/material.dart';
import 'package:preparation_game/managers/board_storage.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'package:preparation_game/screens/home_page.dart';
import 'package:preparation_game/screens/progress_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedBoard = await BoardStorage().load();
  runApp(MyApp(savedBoard: savedBoard));
}

class MyApp extends StatelessWidget {
  final BoardSnapshot? savedBoard;

  const MyApp({super.key, this.savedBoard});

  @override
  Widget build(BuildContext context) {
    final board = savedBoard;

    return MaterialApp(
      title: 'MyPinboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: board == null
          ? const HomePage()
          : ProgressPage(
              challengeTitle: board.title,
              initialSubjects: board.subjectsByLevel,
            ),
    );
  }
}
