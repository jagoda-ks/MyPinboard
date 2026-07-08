import 'package:preparation_game/models/subject.dart';

class BoardManager {
  static List<List<Subject>> deleteMarkedSubjects(
    List<List<Subject>> currentSubjects, 
    Set<String> markedForDeletionIds
  ) {
    // Filter out marked items from each level
    final newSubjects = currentSubjects.map((level) {
      return level.where((s) => !markedForDeletionIds.contains(s.id)).toList();
    }).where((level) => level.isNotEmpty).toList();
    
    return newSubjects.isEmpty ? [[]] : newSubjects;
  }
}