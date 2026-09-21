import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/background_widget.dart';
import 'package:preparation_game/UILib/button_builder.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'package:preparation_game/managers/board_storage.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'progress_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _challengeController;

  @override
  void initState() {
    super.initState();
    _challengeController = TextEditingController();
  }

  @override
  void dispose() {
    _challengeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold in a Container to set the background
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent, // 1. Set to transparent
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.transparent, // 2. Make AppBar transparent
          elevation: 0, // Removes shadow to blend with the background
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter the name of your challenge',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Added white for contrast
                ),
                const SizedBox(height: 16),
                InputField(
                  controller: _challengeController,
                  hintText: 'e.g., Learn Flutter in 30 Days',
                ),
                const SizedBox(height: 24),
                ButtonBuilder()
                    .withText("Let's begin")
                    .onPressed(() async {
                      final String titleInput = _challengeController.text.trim();
                      final String cleanTitle =
                          titleInput.isNotEmpty ? titleInput : 'My Challenge';
                      final snapshot = BoardSnapshot(
                        title: cleanTitle,
                        subjectsByLevel: [[]],
                      );

                      await BoardStorage().save(snapshot);
                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgressPage(
                            challengeTitle: snapshot.title,
                            initialSubjects: snapshot.subjectsByLevel,
                          ),
                        ),
                      );
                    })
                    .build(),
              ],
            ),
          ),
        ),
      );
  }
}