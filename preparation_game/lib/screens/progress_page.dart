import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';
import 'package:preparation_game/UILib/background_widget.dart';
import 'package:preparation_game/UILib/edit_mode_button.dart';
import 'package:preparation_game/UILib/insert_target_gap.dart';
import 'package:preparation_game/UILib/draggable_subject_note.dart';
import 'package:preparation_game/managers/board_storage.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'package:preparation_game/models/subject.dart';
import 'package:preparation_game/utils/roman_converter.dart';
import 'package:preparation_game/managers/board_manager.dart';
import 'package:preparation_game/utils/settings.dart';

class ProgressPage extends StatefulWidget {
  final String challengeTitle;
  final List<List<Subject>>? initialSubjects;

  const ProgressPage({
    super.key,
    required this.challengeTitle,
    this.initialSubjects,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  bool _isEditMode = false;
  bool _showOptions = false;
  bool _isDeleting = false;

  List<List<Subject>> _subjectsByLevel = [[]];
  final Set<String> _markedForDeletionIds = {};

  late final TextEditingController _titleController;
  late String _currentTitle;
  Future<void> _writeChain = Future.value();

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.challengeTitle;
    _titleController = TextEditingController(text: _currentTitle);

    if (widget.initialSubjects != null) {
      _subjectsByLevel = BoardSnapshot.cloneLevels(widget.initialSubjects!);
      if (_subjectsByLevel.isEmpty) _subjectsByLevel = [[]];
    }

    _persist();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _persist() {
    final snapshot = BoardSnapshot(
      title: _currentTitle,
      subjectsByLevel: BoardSnapshot.cloneLevels(_subjectsByLevel),
    );
    _writeChain = _writeChain.then((_) async {
      try {
        await BoardStorage().save(snapshot);
      } catch (_) {}
    });
  }

  void _mutate(VoidCallback changes) {
    setState(changes);
    _persist();
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
    if (!_isEditMode) _persist();
  }

  void _insertSubject({
    required int fromLevel,
    required int fromIndex,
    required int toLevel,
    required int toIndex,
  }) {
    _mutate(() {
      final item = _subjectsByLevel[fromLevel].removeAt(fromIndex);

      var adjustedIndex = toIndex;
      if (fromLevel == toLevel && fromIndex < toIndex) {
        adjustedIndex--;
      }

      if (adjustedIndex >= _subjectsByLevel[toLevel].length) {
        _subjectsByLevel[toLevel].add(item);
      } else {
        _subjectsByLevel[toLevel].insert(adjustedIndex, item);
      }

      _subjectsByLevel.removeWhere((lvl) => lvl.isEmpty);
      if (_subjectsByLevel.isEmpty) _subjectsByLevel = [[]];
    });
  }

  void _swapSubjects({
    required int levelA,
    required int indexA,
    required int levelB,
    required int indexB,
  }) {
    _mutate(() {
      final temp = _subjectsByLevel[levelA][indexA];
      _subjectsByLevel[levelA][indexA] = _subjectsByLevel[levelB][indexB];
      _subjectsByLevel[levelB][indexB] = temp;
    });
  }

  Future<void> _renameSubject({
    required int levelIndex,
    required int itemIndex,
  }) async {
    final subject = _subjectsByLevel[levelIndex][itemIndex];
    final controller = TextEditingController(text: subject.text);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename subject'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Subject name'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (!mounted || newName == null) return;

    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == subject.text) return;
    if (levelIndex >= _subjectsByLevel.length ||
        itemIndex >= _subjectsByLevel[levelIndex].length) {
      return;
    }

    _mutate(() {
      _subjectsByLevel[levelIndex][itemIndex] = subject.copyWith(text: trimmed);
    });
  }

  VoidCallback _noteTapHandler({
    required int levelIndex,
    required int itemIndex,
    required Subject subject,
  }) {
    if (!_isEditMode) return () {};

    if (_isDeleting) {
      return () => setState(() {
            if (_markedForDeletionIds.contains(subject.id)) {
              _markedForDeletionIds.remove(subject.id);
            } else {
              _markedForDeletionIds.add(subject.id);
            }
          });
    }

    return () => _renameSubject(levelIndex: levelIndex, itemIndex: itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double dynamicNoteWidth = (screenWidth * 0.3).clamp(80.0, 200.0);
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canPop
            ? Transform.translate(
                offset: const Offset(-8.0, -10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppSettings.titleColor),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              )
            : null,
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
                    onChanged: (value) {
                      _currentTitle = value.trim().isEmpty
                          ? 'Untitled'
                          : value.trim();
                      _persist();
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Title...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              : Text(_currentTitle, style: AppSettings.pageTitleText),
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
          Positioned.fill(
            child: BackgroundWidget(
              child: InteractiveViewer(
                constrained: false,
                panEnabled: !_isEditMode,
                scaleEnabled: true,
                boundaryMargin: const EdgeInsets.all(500),
                minScale: 0.5,
                maxScale: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _subjectsByLevel
                        .asMap()
                        .entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) {
                      int levelIdx = entry.key;
                      List<Subject> levelSubjects = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              RomanConverter.toRoman(levelIdx + 1),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InsertTargetGap(
                                    targetLevel: levelIdx,
                                    targetIndex: 0,
                                    height: dynamicNoteWidth,
                                    isEditMode: _isEditMode,
                                    isDeleting: _isDeleting,
                                    onInsert: _insertSubject,
                                  ),
                                  ...levelSubjects.asMap().entries.expand((itemEntry) {
                                    int itemIdx = itemEntry.key;
                                    Subject subject = itemEntry.value;

                                    return [
                                      DraggableSubjectNote(
                                        levelIndex: levelIdx,
                                        itemIndex: itemIdx,
                                        subject: subject,
                                        width: dynamicNoteWidth,
                                        isMarked: _markedForDeletionIds.contains(subject.id),
                                        isEditMode: _isEditMode,
                                        isDeleting: _isDeleting,
                                        onTap: _noteTapHandler(
                                          levelIndex: levelIdx,
                                          itemIndex: itemIdx,
                                          subject: subject,
                                        ),
                                        onSwap: _swapSubjects,
                                      ),
                                      InsertTargetGap(
                                        targetLevel: levelIdx,
                                        targetIndex: itemIdx + 1,
                                        height: dynamicNoteWidth,
                                        isEditMode: _isEditMode,
                                        isDeleting: _isDeleting,
                                        onInsert: _insertSubject,
                                      ),
                                    ];
                                  }),
                                ],
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

                    int totalSubjects =
                        _subjectsByLevel.expand((level) => level).length;
                    bool shouldDeleteAll = false;

                    if (totalSubjects > 1) {
                      final bool? result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Delete only selected notes or all duplicates?'),
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

                    _mutate(() {
                      if (shouldDeleteAll) {
                        final textsToDelete = _subjectsByLevel
                            .expand((level) => level.where(
                                (s) => _markedForDeletionIds.contains(s.id)))
                            .map((s) => s.text)
                            .toSet();

                        for (var levelList in _subjectsByLevel) {
                          levelList.removeWhere(
                              (s) => textsToDelete.contains(s.text));
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
          if (_isEditMode)
            Positioned.fill(
              child: SubjectMenu(
                showOptions: _showOptions,
                currentHighestLevel:
                    _subjectsByLevel.where((l) => l.isNotEmpty).length,
                onAddLevel: (levelNum) => _mutate(() {
                  while (_subjectsByLevel.length < levelNum) {
                    _subjectsByLevel.add([]);
                  }
                }),
                onAddSubjectsToLevel: (targetLevel, subjects) => _mutate(() {
                  if (targetLevel < 1 || subjects.isEmpty) return;
                  while (_subjectsByLevel.length < targetLevel) {
                    _subjectsByLevel.add([]);
                  }
                  final now = DateTime.now().microsecondsSinceEpoch;
                  for (var i = 0; i < subjects.length; i++) {
                    final text = subjects[i].trim();
                    if (text.isNotEmpty) {
                      _subjectsByLevel[targetLevel - 1].add(
                        Subject(
                          id: '${now}_${i}_$text',
                          text: text,
                        ),
                      );
                    }
                  }
                }),
                onToggleMenu: () =>
                    setState(() => _showOptions = !_showOptions),
              ),
            ),
        ],
      ),
    );
  }
}
