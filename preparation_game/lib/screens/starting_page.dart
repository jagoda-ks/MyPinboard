import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/input_field.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/UILib/delete_button.dart';
import 'package:preparation_game/UILib/subject_menu.dart';
import 'package:preparation_game/settings.dart'; // Ensure this exists

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

  // Initialize with an empty level to prevent index errors
  List<List<String>> _subjectsByLevel = [[]];
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
    FocusScope.of(context).unfocus();
    final cleanText = value.trim();
    
    if (cleanText.isNotEmpty) {
      setState(() {
        if (_subjectsByLevel.isEmpty) _subjectsByLevel.add([]);
        _subjectsByLevel.last.add(cleanText);
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
        title: Text(widget.challengeTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.edit, color: Colors.white, size: 28)),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // The background board surface
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppSettings.pinboardBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // The interactive board area
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
                  children: _subjectsByLevel.asMap().entries.map((entry) {
                    int index = entry.key;
                    List<String> levelSubjects = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          Row(
                            children: levelSubjects.map((text) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: StickyNoteButton(
                                  text: text,
                                  isMarked: _markedForDeletion.contains(text),
                                  width: dynamicNoteWidth,
                                  onTap: _isDeleting
                                      ? () => setState(() {
                                            if (_markedForDeletion.contains(text)) _markedForDeletion.remove(text);
                                            else _markedForDeletion.add(text);
                                          })
                                      : () {},
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Fixed UI Buttons (Screen Space)
          if (_isEnteringSubject)
            Center(
              child: InputField(
                controller: _subjectInputController,
                hintText: 'Subject Name...',
                onSubmitted: _submitSubject,
              ),
            ),
          
          Positioned(
            bottom: 30,
            left: 20,
            child: DeleteButton(
              isDeleting: _isDeleting,
              enabled: _subjectsByLevel.isNotEmpty,
              onPressed: () => setState(() => _isDeleting = !_isDeleting),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: SubjectMenu(
              showOptions: _showOptions,
              isLevelEnabled: _subjectsByLevel.isNotEmpty,
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
    );
  }
}