import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'package:preparation_game/models/subject.dart';

void main() {
  test('BoardSnapshot round-trips title and nested subjects', () {
    final original = BoardSnapshot(
      title: 'Learn Flutter',
      subjectsByLevel: [
        [Subject(id: 'a', text: 'Widgets')],
        [Subject(id: 'b', text: 'State'), Subject(id: 'c', text: 'Layout')],
      ],
    );

    final restored = BoardSnapshot.fromJson(original.toJson());

    expect(restored.title, 'Learn Flutter');
    expect(restored.subjectsByLevel, hasLength(2));
    expect(restored.subjectsByLevel[0].single.id, 'a');
    expect(restored.subjectsByLevel[0].single.text, 'Widgets');
    expect(restored.subjectsByLevel[1].map((s) => s.text), ['State', 'Layout']);
  });

  test('BoardSnapshot uses a fallback title and drops blank notes', () {
    final restored = BoardSnapshot.fromJson({
      'title': '   ',
      'subjectsByLevel': [
        [
          {'id': '1', 'text': 'Keep'},
          {'id': '2', 'text': '  '},
        ],
      ],
    });

    expect(restored.title, 'My Challenge');
    expect(restored.subjectsByLevel.single.map((s) => s.text), ['Keep']);
  });
}
