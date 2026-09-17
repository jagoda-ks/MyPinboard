import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/add_button.dart';
import 'package:preparation_game/UILib/level_header_row.dart';
import 'package:preparation_game/UILib/subject_input_field.dart';
import 'package:preparation_game/UILib/submit_button.dart';

class SubjectMenu extends StatefulWidget {
  final bool showOptions;
  final int currentHighestLevel;
  final Function(int level) onAddLevel;
  final Function(int level, List<String> subjects) onAddSubjectsToLevel;
  final VoidCallback onToggleMenu;

  const SubjectMenu({
    super.key,
    required this.showOptions,
    required this.currentHighestLevel,
    required this.onAddLevel,
    required this.onAddSubjectsToLevel,
    required this.onToggleMenu,
  });

  @override
  State<SubjectMenu> createState() => _SubjectMenuState();
}

class _SubjectMenuState extends State<SubjectMenu> {
  late TextEditingController _levelInputController;
  List<TextEditingController> _subjectControllers = [];
  bool _isNewMode = true;

  @override
  void initState() {
    super.initState();
    _levelInputController = TextEditingController();
    _subjectControllers = [TextEditingController()];
    _levelInputController.text = (widget.currentHighestLevel + 1).toString();
  }

  @override
  void didUpdateWidget(covariant SubjectMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reset when transitioning from closed to open
    if (widget.showOptions && !oldWidget.showOptions) {
      _resetState();
    }
  }

  void _resetState() {
    final oldControllers = List<TextEditingController>.from(_subjectControllers);

    setState(() {
      _isNewMode = true;
      _levelInputController.text = (widget.currentHighestLevel + 1).toString();
      _subjectControllers = [TextEditingController()];
    });

    // Safely dispose old controllers after the active rebuild completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final controller in oldControllers) {
        controller.dispose();
      }
    });
  }

  void _toggleMode() {
    if (widget.currentHighestLevel <= 0) {
      setState(() {
        _isNewMode = true;
        _levelInputController.text = "1";
      });
      return;
    }

    setState(() {
      _isNewMode = !_isNewMode;
      _levelInputController.text = _isNewMode
          ? (widget.currentHighestLevel + 1).toString()
          : '';
    });
  }

  void _addSubjectLine() {
    if (_subjectControllers.length < 5) {
      setState(() => _subjectControllers.add(TextEditingController()));
    } else {
      _showSnackbar('You can only add up to 5 subjects at once.');
    }
  }

  void _removeSubjectLine(int index) {
    if (_subjectControllers.length > 1) {
      setState(() {
        final controllerToDispose = _subjectControllers.removeAt(index);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controllerToDispose.dispose();
        });
      });
    }
  }

  void _handleSubjectSubmit() {
    // 1. Remove keyboard focus before executing callbacks
    FocusScope.of(context).unfocus();

    final cleanLevelText = _levelInputController.text.trim();
    final parsedLevel = int.tryParse(cleanLevelText);

    final subjectsToAdd = _subjectControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (subjectsToAdd.isEmpty) {
      _showSnackbar('Please enter at least one subject.');
      return;
    }

    if (parsedLevel != null && parsedLevel >= 1) {
      if (!_isNewMode && parsedLevel > widget.currentHighestLevel) {
        _showSnackbar(
          'Please enter a valid level between 1 and ${widget.currentHighestLevel}',
        );
        return;
      }

      widget.onAddSubjectsToLevel(parsedLevel, subjectsToAdd);
      widget.onToggleMenu();
    } else {
      _showSnackbar('Please enter a valid target level.');
    }
  }

  void _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _levelInputController.dispose();
    for (final controller in _subjectControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double popupSize = (screenWidth * 0.85).clamp(300.0, 420.0);

    return Stack(
      children: [
        if (widget.showOptions)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onToggleMenu,
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: popupSize,
                  height: popupSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/popup_note.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 110.0,
                          horizontal: 36.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            LevelHeaderRow(
                              isNewMode: _isNewMode,
                              hasLevels: widget.currentHighestLevel > 0,
                              currentHighestLevel: widget.currentHighestLevel,
                              controller: _levelInputController,
                              onToggleMode: _toggleMode,
                            ),
                            const SizedBox(height: 2),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: [
                                  ..._subjectControllers.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final controller = entry.value;
                                    return SubjectInputField(
                                      index: index,
                                      controller: controller,
                                      canRemove: _subjectControllers.length > 1,
                                      onRemove: () => _removeSubjectLine(index),
                                    );
                                  }),
                                  if (_subjectControllers.length < 5)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: _addSubjectLine,
                                        icon: const Icon(
                                          IconData(
                                            0x002b,
                                            fontFamily: 'CustomFont2',
                                          ),
                                          color: Colors.black87,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          'Add another subject',
                                          style: TextStyle(
                                            fontFamily: 'CustomFont2',
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SubmitButton(onTap: _handleSubjectSubmit),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: AddButton(onPressed: widget.onToggleMenu),
        ),
      ],
    );
  }
}