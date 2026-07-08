import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';
import 'package:preparation_game/UILib/background_widget.dart';
import 'package:preparation_game/models/subject.dart';
import 'package:preparation_game/utils/roman_converter.dart';
import 'package:preparation_game/managers/board_manager.dart';
import 'package:preparation_game/utils/settings.dart';

class StartingPage extends StatefulWidget {
  final String challengeTitle;
  const StartingPage({super.key, required this.challengeTitle});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  bool _showOptions = false;
  bool _isEnteringSubject = false;
  bool _isDeleting = false;

  List<List<Subject>> _subjectsByLevel = [[]];
  final Set<String> _markedForDeletionIds = {};
  late final TextEditingController _subjectInputController;

  @override
  void initState() {
    super.initState();
    _subjectInputController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectInputController.dispose();
    super.dispose();
  }

  void _submitSubject(String value) {
    FocusScope.of(context).unfocus();
    final cleanText = value.trim();
    if (cleanText.isNotEmpty) {
      setState(() {
        if (_subjectsByLevel.isEmpty) _subjectsByLevel.add([]);
        _subjectsByLevel.last.add(Subject(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: cleanText,
        ));
        _subjectInputController.clear();
        _isEnteringSubject = false;
      });
    } else {
      setState(() => _isEnteringSubject = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double dynamicNoteWidth = (screenWidth * 0.3).clamp(80.0, 200.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.challengeTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(AppSettings.pinboardBackground), fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.5,
              maxScale: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _subjectsByLevel.asMap().entries.where((entry) => entry.value.isNotEmpty).map((entry) {
                    int index = entry.key;
                    List<Subject> levelSubjects = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          // This will now only render if the level has items
                          Text(
                            RomanConverter.toRoman(index + 1),
                            style: const TextStyle(color: Color.fromARGB(255, 177, 146, 101), fontFamily: AppSettings.customFontFamily, fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: levelSubjects.map((subject) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: StickyNoteButton(
                                  text: subject.text,
                                  isMarked: _markedForDeletionIds.contains(subject.id),
                                  width: dynamicNoteWidth,
                                  onTap: _isDeleting 
                                      ? () => setState(() {
                                          if (_markedForDeletionIds.contains(subject.id)) _markedForDeletionIds.remove(subject.id);
                                          else _markedForDeletionIds.add(subject.id);
                                        })
                                      : () {},
                                ),
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          if (_isEnteringSubject) Center(child: InputField(controller: _subjectInputController, hintText: 'Subject Name...', onSubmitted: _submitSubject)),
          Positioned(
            bottom: 30, left: 20,
            child: DeleteButton(
              isDeleting: _isDeleting,
              enabled: _subjectsByLevel.any((l) => l.isNotEmpty),
              onPressed: () async {
                if (_isDeleting) {
                  // 1. Check if nothing is selected
                  if (_markedForDeletionIds.isEmpty) {
                    setState(() => _isDeleting = false);
                    return;
                  }

                  // 2. Count total notes across all levels
                  int totalSubjects = _subjectsByLevel.expand((level) => level).length;

                  // 3. Determine if we need to show the popup
                  // Popup only appears if total notes > 1. 
                  // If totalSubjects <= 1, we skip the popup and default to 'Selected Only' (shouldDeleteAll = false)
                  bool shouldDeleteAll = false;

                  if (totalSubjects > 1) {
                    final bool? result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text('Delete only selected notes or all duplicates?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false), // Selected Only
                            child: const Text('Selected Only'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true), // All Matching
                            child: const Text('All Matching'),
                          ),
                        ],
                      ),
                    );
                    
                    // If user dismisses the dialog without picking, exit
                    if (result == null) return;
                    shouldDeleteAll = result;
                  }

                  // 4. Perform the deletion
                  setState(() {
                    if (shouldDeleteAll) {
                      // Collect text of ALL selected notes to identify all duplicates
                      final textsToDelete = _subjectsByLevel
                          .expand((level) => level.where((s) => _markedForDeletionIds.contains(s.id)))
                          .map((s) => s.text)
                          .toSet();

                      for (var levelList in _subjectsByLevel) {
                        levelList.removeWhere((s) => textsToDelete.contains(s.text));
                      }
                    } else {
                      // Delete only the specifically marked instances (or the single note)
                      _subjectsByLevel = BoardManager.deleteMarkedSubjects(
                        _subjectsByLevel, 
                        _markedForDeletionIds
                      );
                    }
                    
                    // Clean up selections and empty rows
                    _markedForDeletionIds.clear();
                    _subjectsByLevel.removeWhere((level) => level.isEmpty);
                    if (_subjectsByLevel.isEmpty) _subjectsByLevel = [[]];
                  });
                }

                // Toggle deletion mode
                setState(() => _isDeleting = !_isDeleting);
              },
            ),
          ),
          Positioned(
            bottom: 30, right: 20,
            child: SubjectMenu(
              showOptions: _showOptions,
              isLevelEnabled: true,
              onAddLevel: () => setState(() => _subjectsByLevel.add([])),
              onAddSubject: () => setState(() { _isEnteringSubject = true; _showOptions = false; }),
              onToggleMenu: () => setState(() => _showOptions = !_showOptions),
            ),
          ),
        ],
      ),
    );
  }
}