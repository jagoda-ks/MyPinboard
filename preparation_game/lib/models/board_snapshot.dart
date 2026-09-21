import 'package:preparation_game/models/subject.dart';

class BoardSnapshot {
  final String title;
  final List<List<Subject>> subjectsByLevel;

  BoardSnapshot({
    required this.title,
    required this.subjectsByLevel,
  });

  BoardSnapshot copy() {
    return BoardSnapshot(
      title: title,
      subjectsByLevel: cloneLevels(subjectsByLevel),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subjectsByLevel': [
          for (final level in subjectsByLevel)
            [for (final subject in level) subject.toJson()],
        ],
      };

  factory BoardSnapshot.fromJson(Map<String, dynamic> json) {
    final rawLevels = json['subjectsByLevel'] as List<dynamic>? ?? const [];
    final levels = rawLevels.map((level) {
      final items = level as List<dynamic>;
      return items
          .map((item) => Subject.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((subject) => subject.text.trim().isNotEmpty)
          .toList();
    }).toList();

    final rawTitle = (json['title'] as String?)?.trim() ?? '';

    return BoardSnapshot(
      title: rawTitle.isEmpty ? 'My Challenge' : rawTitle,
      subjectsByLevel: levels.isEmpty ? [[]] : levels,
    );
  }

  static List<List<Subject>> cloneLevels(List<List<Subject>> levels) {
    return [for (final level in levels) List<Subject>.from(level)];
  }
}
