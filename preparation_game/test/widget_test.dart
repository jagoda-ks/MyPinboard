import 'package:flutter_test/flutter_test.dart';
import 'package:preparation_game/main.dart';
import 'package:preparation_game/models/board_snapshot.dart';
import 'package:preparation_game/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the home screen when nothing is saved', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Enter the name of your challenge'), findsOneWidget);
  });

  testWidgets('opens the board with the saved title and notes', (tester) async {
    await tester.pumpWidget(
      MyApp(
        savedBoard: BoardSnapshot(
          title: 'Saved Challenge',
          subjectsByLevel: [
            [Subject(id: '1', text: 'Algebra')],
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Saved Challenge'), findsOneWidget);
    expect(find.text('Algebra'), findsOneWidget);
  });
}
