import 'package:preparation_game/models/subject.dart';

class DraggedSubjectPayload {
  final int fromLevelIndex;
  final int fromItemIndex;
  final Subject subject;

  const DraggedSubjectPayload({
    required this.fromLevelIndex,
    required this.fromItemIndex,
    required this.subject,
  });
}