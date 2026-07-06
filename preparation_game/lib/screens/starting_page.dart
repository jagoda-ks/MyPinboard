import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';

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

  final List<String> _subjects = [];
  final List<String> _levels = [];
  final Set<String> _markedForDeletion = {};

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
    final cleanText = value.trim();
    if (cleanText.isNotEmpty) {
      setState(() {
        _subjects.add(cleanText);
        _subjectInputController.clear();
        _isEnteringSubject = false;
        _showOptions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLevelEnabled = _subjects.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pinboard.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.challengeTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Text('H', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_levels.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _levels.map((lvl) => Chip(label: Text(lvl))).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isEnteringSubject
                          ? InputField(
                              key: const ValueKey('input_field'),
                              controller: _subjectInputController,
                              hintText: 'Subject Name & press Enter...',
                              onSubmitted: _submitSubject,
                            )
                          : _subjects.isNotEmpty
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _subjects.map((text) {
                                    final isMarked = _markedForDeletion.contains(text);
                                    return StickyNoteButton(
                                      key: ValueKey(text),
                                      text: text,
                                      isMarked: isMarked,
                                      onTap: _isDeleting
                                          ? () => setState(() {
                                                if (isMarked) {
                                                  _markedForDeletion.remove(text);
                                                } else {
                                                  _markedForDeletion.add(text);
                                                }
                                              })
                                          : () {}, 
                                    );
                                  }).toList(),
                                )
                              : const Text('No subjects added yet.', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
            
            // Reusable Delete Button
            Positioned(
              bottom: 20,
              left: 20,
              child: DeleteButton(
                isDeleting: _isDeleting,
                enabled: _subjects.isNotEmpty,
                onPressed: () => setState(() => _isDeleting = !_isDeleting),
              ),
            ),

            // Reusable Menu
            Positioned(
              bottom: 20,
              right: 20,
              child: SubjectMenu(
                showOptions: _showOptions,
                isLevelEnabled: isLevelEnabled,
                onAddLevel: () => setState(() => _levels.add('Level ${_levels.length + 1}')),
                onAddSubject: () => setState(() => _isEnteringSubject = true),
                onToggleMenu: () => setState(() {
                  _showOptions = !_showOptions;
                  if (!_showOptions) {
                    _isEnteringSubject = false;
                    _isDeleting = false;
                    _markedForDeletion.clear();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}