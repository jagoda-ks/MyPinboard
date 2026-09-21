import 'package:flutter/material.dart';
import 'package:preparation_game/models/dragged_subject_payload.dart';

class InsertTargetGap extends StatelessWidget {
  final int targetLevel;
  final int targetIndex;
  final double height;
  final bool isEditMode;
  final bool isDeleting;
  final Function({
    required int fromLevel,
    required int fromIndex,
    required int toLevel,
    required int toIndex,
  }) onInsert;

  const InsertTargetGap({
    super.key,
    required this.targetLevel,
    required this.targetIndex,
    required this.height,
    required this.isEditMode,
    required this.isDeleting,
    required this.onInsert,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<DraggedSubjectPayload>(
      onWillAcceptWithDetails: (details) => isEditMode && !isDeleting,
      onAcceptWithDetails: (details) {
        final data = details.data;
        onInsert(
          fromLevel: data.fromLevelIndex,
          fromIndex: data.fromItemIndex,
          toLevel: targetLevel,
          toIndex: targetIndex,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isHovered ? 24.0 : 8.0,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: isHovered ? Colors.amber.withValues(alpha: 0.6) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}