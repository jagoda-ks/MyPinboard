import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/add_button.dart';

class SubjectMenu extends StatefulWidget {
  final bool showOptions;
  final int currentHighestLevel;
  final Function(int level) onAddLevel;
  final Function(int level) onAddSubjectToLevel; // 👈 Passes target level to parent
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
  bool _isNewMode = true;

  @override
  void initState() {
    super.initState();
    _levelInputController = TextEditingController();
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
    });
  }

  void _toggleMode() {
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
    final cleanText = _levelInputController.text.trim();
    final parsedLevel = int.tryParse(cleanText);

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

      // Pass the level read from the input box to the parent page
      widget.onAddSubjectToLevel(parsedLevel);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double popupSize = (screenWidth * 0.85).clamp(300.0, 380.0);
    final y = widget.currentHighestLevel;

    return Stack(
      children: [
        // 1. Overlay Backdrop + Card
        if (widget.showOptions)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onToggleMenu,
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {}, // Prevent taps inside card from closing backdrop
                child: SizedBox(
                  width: popupSize,
                  height: popupSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Card Asset
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/popup_note.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Card Internal Content with custom margins
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 40.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // TOP ROW: [TextButton] | [Plain Level Text] | [Input Field]
                            Transform.translate(
                              offset: const Offset(0, -6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // NEW / EXISTENT Button
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

                                  // Middle: Plain Text "Level"
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

                                  // Right: Input Field
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

                            // BOTTOM ROW: Add Subject Button
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _handleSubjectSubmit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_task,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Add Subject',
                                      style: TextStyle(
                                        fontFamily: 'CustomFont2',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
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

        // 2. Custom Add Button
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