import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/add_button.dart'; // 👈 Import new AddButton widget

class SubjectMenu extends StatelessWidget {
  final bool showOptions;
  final bool isLevelEnabled;
  final VoidCallback onAddLevel;
  final VoidCallback onAddSubject;
  final VoidCallback onToggleMenu;

  const SubjectMenu({
    super.key,
    required this.showOptions,
    required this.isLevelEnabled,
    required this.onAddLevel,
    required this.onAddSubject,
    required this.onToggleMenu,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double popupSize = (screenWidth * 0.75).clamp(280.0, 360.0);

    return Stack(
      children: [
        // 1. Fullscreen Dim Backdrop & Centered Popup Note
        if (showOptions)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggleMenu, // Tap outside closes the note
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {}, // Prevent taps on the note from closing it
                child: SizedBox(
                  width: popupSize,
                  height: popupSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Note Image Background
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/popup_note.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Options Layout
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 32.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // TOP: Add Level
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: isLevelEnabled
                                  ? () {
                                      onAddLevel();
                                      onToggleMenu();
                                    }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted_add,
                                    size: 26,
                                    color: isLevelEnabled
                                        ? Colors.black87
                                        : Colors.black38,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Add Level',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isLevelEnabled
                                          ? Colors.black87
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // BOTTOM: Add Subject
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                onAddSubject();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_task,
                                    size: 26,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Add Subject',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
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
          ),

        // 2. Custom Image Add Button (Anchored Bottom Right)
        Positioned(
          bottom: 0, // 👈 Flush with the bottom edge
          right: 0,  // 👈 Flush with the right edge
          child: AddButton(
            onPressed: onToggleMenu,
            size: 200.0, // Adjusting size now expands up & left from the corner
          ),
        ),
      ],
    );
  }
}