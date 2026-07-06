import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/input_field.dart';

class StartingPage extends StatefulWidget {
  final String challengeTitle;

  const StartingPage({
    super.key,
    required this.challengeTitle,
  });

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  bool _showOptions = false;
  bool _isEnteringSubject = false; // Renamed from _isEnteringComponent
  bool _isDeleting = false;

  final List<String> _subjects = []; // Renamed from _components
  final List<String> _levels = [];
  final Set<String> _markedForDeletion = {};

  late final TextEditingController _subjectInputController; // Renamed

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

  void _submitSubject(String value) { // Renamed
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

  void _performDeletion() {
    setState(() {
      _subjects.removeWhere((item) => _markedForDeletion.contains(item));
      _markedForDeletion.clear();
      _isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLevelEnabled = _subjects.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
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
                                    return SizedBox(
                                      key: ValueKey(text),
                                      width: 120,
                                      height: 70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isMarked ? Colors.redAccent : null,
                                        ),
                                        onPressed: _isDeleting
                                            ? () => setState(() {
                                                if (isMarked) _markedForDeletion.remove(text);
                                                else _markedForDeletion.add(text);
                                              })
                                            : () {}, // Normal action
                                        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Text('No subjects added yet.', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: _isDeleting ? Colors.red.shade800 : Colors.red,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _isDeleting ? [const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))] : [],
                ),
                child: ElevatedButton(
                  onPressed: _subjects.isNotEmpty
                      ? () => setState(() => _isDeleting = !_isDeleting)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Icon(_isDeleting ? Icons.check : Icons.delete, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(_isDeleting ? 'Finish Deleting' : 'Delete', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_showOptions) ...[
                    ElevatedButton(
                      onPressed: isLevelEnabled
                          ? () => setState(() => _levels.add('Level ${_levels.length + 1}'))
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: isLevelEnabled ? null : Colors.grey[300]),
                      child: const Text('Level'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() => _isEnteringSubject = true),
                      child: const Text('Subject'),
                    ),
                    const SizedBox(height: 10),
                  ],
                  FloatingActionButton.extended(
                    onPressed: () => setState(() {
                      _showOptions = !_showOptions;
                      if (!_showOptions) {
                        _isEnteringSubject = false;
                        _isDeleting = false;
                        _markedForDeletion.clear();
                      }
                    }),
                    label: Text(_showOptions ? 'Hide' : 'Add'),
                    icon: Icon(_showOptions ? Icons.close : Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}