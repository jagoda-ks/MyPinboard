import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';
import 'package:preparation_game/UILib/background_widget.dart';
import 'package:preparation_game/UILib/edit_mode_button.dart';
import 'package:preparation_game/models/subject.dart';
import 'package:preparation_game/utils/roman_converter.dart';
import 'package:preparation_game/managers/board_manager.dart';
import 'package:preparation_game/utils/settings.dart';

class ProgressPage extends StatefulWidget {
  final String challengeTitle;
  const ProgressPage({super.key, required this.challengeTitle});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Mode & UI Flags
  bool _isEditMode = false;
  bool _showOptions = false;
  bool _isDeleting = false;
  int _targetLevelForSubject = 1;

  // Board Data & Selection
  List<List<Subject>> _subjectsByLevel = [[]];
  final Set<String> _markedForDeletionIds = {};

  // Controllers & State variables
  late final TextEditingController _titleController;
  late String _currentTitle;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.challengeTitle;
    _titleController = TextEditingController(text: _currentTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _isDeleting = false;
        _showOptions = false;
        _markedForDeletionIds.clear();
        _currentTitle = _titleController.text.trim().isEmpty
            ? 'Untitled'
            : _titleController.text.trim();
      }
    });
  }

  // Handles adding the subject directly to the target level passed from the popup menu
  void _addSubjectToLevel(int targetLevel, String subjectText) {
    final cleanText = subjectText.trim();
    if (cleanText.isNotEmpty) {
      setState(() {
        while (_subjectsByLevel.length < targetLevel) {
          _subjectsByLevel.add([]);
        }
        _subjectsByLevel[targetLevel - 1].add(Subject(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: cleanText,
        ));
      });
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform.translate(
          offset: const Offset(-8.0, -10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppSettings.titleColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Transform.translate(
          offset: const Offset(0, -10.0),
          child: _isEditMode
              ? SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: AppSettings.pageTitleText,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Title...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              : Text(
                  _currentTitle,
                  style: AppSettings.pageTitleText,
                ),
        ),
        actions: [
          EditModeButton(
            isEditMode: _isEditMode,
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Background Board & Levels Rendering
          Positioned.fill(
            child: BackgroundWidget(
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(500),
                minScale: 0.5,
                maxScale: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _subjectsByLevel
                        .asMap()
                        .entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) {
                      int index = entry.key;
                      List<Subject> levelSubjects = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Text(
                              RomanConverter.toRoman(index + 1),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 177, 146, 101),
                                fontFamily: AppSettings.customFontFamily,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
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
                                        onTap: (_isEditMode && _isDeleting)
                                            ? () => setState(() {
                                                if (_markedForDeletionIds.contains(subject.id)) {
                                                  _markedForDeletionIds.remove(subject.id);
                                                } else {
                                                  _markedForDeletionIds.add(subject.id);
                                                }
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
          ),

          // 2. Delete Button Logic
          if (_isEditMode)
            Positioned(
              bottom: 30,
              left: 20,
              child: DeleteButton(
                isDeleting: _isDeleting,
                enabled: _subjectsByLevel.any((l) => l.isNotEmpty),
                onPressed: () async {
                  if (_isDeleting) {
                    if (_markedForDeletionIds.isEmpty) {
                      setState(() => _isDeleting = false);
                      return;
                    }

                    int totalSubjects = _subjectsByLevel.expand((level) => level).length;
                    bool shouldDeleteAll = false;

                    if (totalSubjects > 1) {
                      final bool? result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Delete only selected notes or all duplicates?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Selected Only'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('All Matching'),
                            ),
                          ],
                        ),
                      );

                      if (result == null) return;
                      shouldDeleteAll = result;
                    }

                    setState(() {
                      if (shouldDeleteAll) {
                        final textsToDelete = _subjectsByLevel
                            .expand((level) => level.where((s) => _markedForDeletionIds.contains(s.id)))
                            .map((s) => s.text)
                            .toSet();

                        for (var levelList in _subjectsByLevel) {
                          levelList.removeWhere((s) => textsToDelete.contains(s.text));
                        }
                      } else {
                        _subjectsByLevel = BoardManager.deleteMarkedSubjects(
                          _subjectsByLevel,
                          _markedForDeletionIds,
                        );
                      }

                      _markedForDeletionIds.clear();
                      _subjectsByLevel.removeWhere((level) => level.isEmpty);
                      if (_subjectsByLevel.isEmpty) _subjectsByLevel = [[]];
                    });
                  }

                  setState(() => _isDeleting = !_isDeleting);
                },
              ),
            ),

          // 3. Add Menu with Popup Note Overlay & Integrated Input Field
          if (_isEditMode)
            Positioned.fill(
              child: SubjectMenu(
                showOptions: _showOptions,
                currentHighestLevel: _subjectsByLevel
                    .where((level) => level.isNotEmpty)
                    .length,
                onAddLevel: (targetLevel) {
                  setState(() {
                    while (_subjectsByLevel.length < targetLevel) {
                      _subjectsByLevel.add([]);
                    }
                  });
                },
                onAddSubjectToLevel: (targetLevel, subjectText) {
                  setState(() {
                    _targetLevelForSubject = targetLevel;
                    _addSubjectToLevel(targetLevel, subjectText); // 👈 Passes text to board creation method
                  });
                },
                onToggleMenu: () => setState(() => _showOptions = !_showOptions),
              ),
            ),
        ],
      ),
    );
  }
}