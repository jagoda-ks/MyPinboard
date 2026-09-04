import 'package:flutter/material.dart';

class LevelHeaderRow extends StatelessWidget {
  final bool isNewMode;
  final bool hasLevels;
  final int currentHighestLevel;
  final TextEditingController controller;
  final VoidCallback onToggleMode;

  const LevelHeaderRow({
    super.key,
    required this.isNewMode,
    required this.hasLevels,
    required this.currentHighestLevel,
    required this.controller,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    // Matching width on both outer sides keeps "Level" centered
    const double outerSlotWidth = 80.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. LEFT: NEW / EXISTENT Button
        Container(
          width: outerSlotWidth,
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: hasLevels ? onToggleMode : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              isNewMode ? 'NEW' : 'EXISTENT',
              style: TextStyle(
                fontFamily: 'CustomFont2',
                fontSize: 13,
                color: hasLevels ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),

        // 2. CENTER: "Level" text in the middle
        const Expanded(
          child: Center(
            child: Text(
              'Level',
              style: TextStyle(
                fontFamily: 'CustomFont2',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),

        // 3. RIGHT: Level Number Input
        Container(
          width: outerSlotWidth,
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 55,
            height: 32,
            child: TextField(
              controller: controller,
              enabled: !isNewMode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontFamily: 'CustomFont2',
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '1 - $currentHighestLevel',
                hintStyle: TextStyle(
                  fontFamily: 'CustomFont2',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}