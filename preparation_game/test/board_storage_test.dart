import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_game/managers/board_storage.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'package:preparation_game/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('BoardStorage saves and reloads a board', () async {
    final storage = BoardStorage();
    expect(await storage.load(), isNull);

    final snapshot = BoardSnapshot(
      title: 'Exam prep',
      subjectsByLevel: [
        [Subject(id: 'note-1', text: 'History')],
      ],
    );

    await storage.save(snapshot);
    final loaded = await storage.load();

    expect(loaded, isNotNull);
    expect(loaded!.title, 'Exam prep');
    expect(loaded.subjectsByLevel.single.single.text, 'History');
  });
}
