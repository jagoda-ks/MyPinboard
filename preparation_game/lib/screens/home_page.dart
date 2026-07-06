import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/button_builder.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'starting_page.dart';

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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pinboard.png'), // Ensure this matches your file name
          fit: BoxFit.cover, // Ensures the image fills the screen
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // 1. Set to transparent
        appBar: AppBar(
          title: const Text('Challenge App'),
          backgroundColor: Colors.transparent, // 2. Make AppBar transparent
          elevation: 0, // Removes shadow to blend with the background
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    .onPressed(() {
                      final String titleInput = _challengeController.text.trim();
                      final String cleanTitle = titleInput.isNotEmpty ? titleInput : 'My Challenge';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartingPage(challengeTitle: cleanTitle),
                        ),
                      );
                    })
                    .build(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}