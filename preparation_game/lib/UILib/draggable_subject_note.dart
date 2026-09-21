import 'package:flutter/material.dart';
import 'package:preparation_game/UILib/sticky_note_button.dart';
import 'package:preparation_game/models/dragged_subject_payload.dart';
import 'package:preparation_game/models/subject.dart';

class DraggableSubjectNote extends StatelessWidget {
  final int levelIndex;
  final int itemIndex;
  final Subject subject;
  final double width;
  final bool isMarked;
  final bool isEditMode;
  final bool isDeleting;
  final VoidCallback onTap;
  final Function({
    required int levelA,
    required int indexA,
    required int levelB,
    required int indexB,
  }) onSwap;

  const DraggableSubjectNote({
    super.key,
    required this.levelIndex,
    required this.itemIndex,
    required this.subject,
    required this.width,
    required this.isMarked,
    required this.isEditMode,
    required this.isDeleting,
    required this.onTap,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final noteWidget = StickyNoteButton(
      text: subject.text,
      isMarked: isMarked,
      width: width,
      onTap: onTap,
    );

    return DragTarget<DraggedSubjectPayload>(
      onWillAcceptWithDetails: (details) =>
          isEditMode && !isDeleting && details.data.subject.id != subject.id,
      onAcceptWithDetails: (details) {
        final data = details.data;
        onSwap(
          levelA: data.fromLevelIndex,
          indexA: data.fromItemIndex,
          levelB: levelIndex,
          indexB: itemIndex,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        final currentNote = AnimatedScale(
          scale: isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: noteWidget,
        );

        if (isEditMode && !isDeleting) {
          return LongPressDraggable<DraggedSubjectPayload>(
            data: DraggedSubjectPayload(
              fromLevelIndex: levelIndex,
              fromItemIndex: itemIndex,
              subject: subject,
            ),
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(opacity: 0.8, child: noteWidget),
            ),
            childWhenDragging: Opacity(opacity: 0.2, child: noteWidget),
            child: currentNote,
          );
        }

        return currentNote;
      },
    );
  }
}