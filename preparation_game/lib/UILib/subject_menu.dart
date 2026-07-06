import 'package:flutter/material.dart';

class SubjectMenu extends StatelessWidget {
  final bool showOptions;
  final bool isLevelEnabled;
  final VoidCallback onAddLevel;
  final VoidCallback onAddSubject;
  final VoidCallback onToggleMenu;

  const SubjectMenu({
    super.key,
    required this.showOptions,
    required this.isLevelEnabled,
    required this.onAddLevel,
    required this.onAddSubject,
    required this.onToggleMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showOptions) ...[
          ElevatedButton(
            onPressed: isLevelEnabled ? onAddLevel : null,
            style: ElevatedButton.styleFrom(backgroundColor: isLevelEnabled ? null : Colors.grey[300]),
            child: const Text('Level'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onAddSubject,
            child: const Text('Subject'),
          ),
          const SizedBox(height: 10),
        ],
        FloatingActionButton.extended(
          onPressed: onToggleMenu,
          label: Text(showOptions ? 'Hide' : 'Add'),
          icon: Icon(showOptions ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}