import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';
import 'package:preparation_game/UILib/background_widget.dart';
import 'package:preparation_game/UILib/scroll_panel.dart';

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

  List<List<String>> _subjectsByLevel = [];
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
        if (_subjectsByLevel.isEmpty) {
          _subjectsByLevel.add([]);
        }
        _subjectsByLevel.last.add(cleanText);
        _subjectInputController.clear();
        _isEnteringSubject = false;
        _showOptions = false;
      });
    } else {
      setState(() => _isEnteringSubject = false);
    }
  }

@override
  Widget build(BuildContext context) {
    final bool isLevelEnabled = _subjectsByLevel.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final double dynamicNoteWidth = (screenWidth * 0.3).clamp(80.0, 200.0);

    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.challengeTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.edit, color: Colors.white, size: 28)),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            ScrollPanel(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_subjectsByLevel.isEmpty && !_isEnteringSubject)
                        const Text('No subjects added yet.', style: TextStyle(color: Colors.white, fontSize: 16)),
                      
                      // Map the rows
                      ..._subjectsByLevel.asMap().entries.map((entry) {
                        int index = entry.key;
                        List<String> levelSubjects = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: levelSubjects.map((text) {
                                      final isMarked = _markedForDeletion.contains(text);
                                      return StickyNoteButton(
                                        key: ValueKey(text),
                                        text: text,
                                        isMarked: isMarked,
                                        width: dynamicNoteWidth,
                                        onTap: _isDeleting
                                            ? () => setState(() {
                                                if (isMarked) _markedForDeletion.remove(text);
                                                else _markedForDeletion.add(text);
                                              })
                                            : () {},
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                        );
                      }),

                      if (_isEnteringSubject)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: InputField(
                            key: UniqueKey(),
                            controller: _subjectInputController,
                            hintText: 'Subject Name & press Enter...',
                            onSubmitted: _submitSubject,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // ... Positioned buttons remain the same
            Positioned(
              bottom: 20,
              left: 20,
              child: DeleteButton(
                isDeleting: _isDeleting,
                enabled: _subjectsByLevel.isNotEmpty,
                onPressed: () => setState(() => _isDeleting = !_isDeleting),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: SubjectMenu(
                showOptions: _showOptions,
                isLevelEnabled: isLevelEnabled,
                onAddLevel: () => setState(() => _subjectsByLevel.add([])),
                onAddSubject: () => setState(() {
                  _isEnteringSubject = true;
                  _showOptions = false;
                }),
                onToggleMenu: () => setState(() => _showOptions = !_showOptions),
              ),
            ),
          ],
        ),
      ),
    );
  }
}