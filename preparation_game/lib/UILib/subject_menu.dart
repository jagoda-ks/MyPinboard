import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/add_button.dart';

class SubjectMenu extends StatefulWidget {
  final bool showOptions;
  final int currentHighestLevel;
  final Function(int level) onAddLevel;
  final Function(int level, String subjectText) onAddSubjectToLevel; // 👈 Accept 2 arguments here
  final VoidCallback onToggleMenu;

  const SubjectMenu({
    super.key,
    required this.showOptions,
    required this.currentHighestLevel,
    required this.onAddLevel,
    required this.onAddSubjectToLevel,
    required this.onToggleMenu,
  });

  @override
  State<SubjectMenu> createState() => _SubjectMenuState();
}

class _SubjectMenuState extends State<SubjectMenu> {
  late TextEditingController _levelInputController;
  late TextEditingController _subjectInputController; // 👈 Controller for subject name
  bool _isNewMode = true;

  @override
  void initState() {
    super.initState();
    _levelInputController = TextEditingController();
    _subjectInputController = TextEditingController(); // 👈 Initialize subject controller
    _resetState();
  }

  @override
  void didUpdateWidget(covariant SubjectMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOptions != oldWidget.showOptions && widget.showOptions) {
      _resetState();
    }
  }

  void _resetState() {
    setState(() {
      _isNewMode = true;
      _levelInputController.text = (widget.currentHighestLevel + 1).toString();
      _subjectInputController.clear();
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
      if (_isNewMode) {
        _levelInputController.text = (widget.currentHighestLevel + 1).toString();
      } else {
        _levelInputController.clear();
      }
    });
  }

  void _handleSubjectSubmit() {
      final cleanLevelText = _levelInputController.text.trim();
      final parsedLevel = int.tryParse(cleanLevelText);
      final subjectText = _subjectInputController.text.trim(); // 👈 Grab typed subject name

      if (parsedLevel != null && parsedLevel >= 1) {
        if (!_isNewMode && parsedLevel > widget.currentHighestLevel) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enter a valid level between 1 and ${widget.currentHighestLevel}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // 👈 Pass both arguments up to the parent page
        widget.onAddSubjectToLevel(parsedLevel, subjectText);
        widget.onToggleMenu();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a valid target level.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

  @override
  void dispose() {
    _levelInputController.dispose();
    _subjectInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double popupSize = (screenWidth * 0.85).clamp(300.0, 380.0);
    final y = widget.currentHighestLevel;

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
                          vertical: 5.0,
                          horizontal: 40.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // TOP ROW: [TextButton] | [Plain Level Text] | [Level Input Field]
                            Transform.translate(
                              offset: const Offset(0, -6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: _toggleMode,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 2.0,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      _isNewMode ? 'NEW' : 'EXISTENT',
                                      style: const TextStyle(
                                        fontFamily: 'CustomFont2',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Text(
                                      'Level',
                                      style: TextStyle(
                                        fontFamily: 'CustomFont2',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 75,
                                    height: 50,
                                    child: TextField(
                                      controller: _levelInputController,
                                      enabled: !_isNewMode,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'CustomFont2',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '1 - $y',
                                        hintStyle: TextStyle(
                                          fontFamily: 'CustomFont2',
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // BOTTOM ROW: Subject Input Field placed right next to the 'Add Subject' button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Subject Name Text Input Field (Appears right next to the button)
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: _subjectInputController,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontFamily: 'CustomFont2',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Subject Name...',
                                        hintStyle: TextStyle(
                                          fontFamily: 'CustomFont2',
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Add Subject Button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    // You can include the subject name from _subjectInputController here if needed
                                    _handleSubjectSubmit();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add_task,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                            fontFamily: 'CustomFont2',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
        Positioned(
          bottom: 0,
          right: 0,
          child: AddButton(
            onPressed: widget.onToggleMenu,
          ),
        ),
      ],
    );
  }
}