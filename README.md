# MyPinboard

MyPinboard is a Flutter app for making **goal planning** easier.

Planning is **multi-layered**: a goal sits on the corkboard, then splits into levels, then into individual sticky notes. The point is to break a large workflow into smaller steps so the whole thing feels feasible instead of like one overwhelming task.

For example, *Learn Flutter in 30 Days* can become level I for widgets, level II for state, and a later level for a first project — each note a piece you can actually start.

The app is still in progress: you can name a goal, lay out the board, and come back to it later. Links between notes, difficulty pins, progress tracking, and a place to write about each subject are not built yet.

The Flutter project lives in [`preparation_game/`](preparation_game/).

## Features already in the app

- **Goal title** on the home screen, carried onto the board (editable later).
- **Corkboard UI** with a wooden board, picture frame, sticky notes, and pins.
- **Levels** (I, II, III, …) as rows of notes on a pan-and-zoom canvas.
- **Edit mode** to add, rearrange, rename, and delete notes without accidentally moving them while browsing.
- **Add subjects** through a popup: create a new level or append to an existing one (up to five names at a time).
- **Drag and drop** in edit mode:
  - drop a note onto another note to **swap** them
  - drop it into a gap to **insert** it at that position (including another level)
- **Delete** selected notes, or every note that shares the same text.
- **Local save** of the title, levels, and notes on the device. Closing and reopening the app restores the last board.

## Screens

| Screen | What it does |
| --- | --- |
| **Home** | First launch only: asks for a challenge name and opens the board. An empty name becomes `My Challenge`. |
| **Progress board** | Shows the pinboard. After the first save, this is the screen that opens on launch. |

### Edit mode

1. Tap the pencil in the app bar.
2. Tap the add control (bottom-right) to open the subject popup.
3. Choose **NEW** (next unused level) or **EXISTENT** (type an existing level number).
4. Enter one or more subject names and tap **Add Subjects**.
5. Tap a note to rename it.
6. Long-press a note to drag it: onto another note to swap, or onto a highlighted gap to insert.
7. Tap **Delete**, mark notes, then confirm. If more than one note exists, you can remove only the marked ones or every note with matching text.

Panning the canvas is disabled while editing so drags go to the notes instead of the board.

## Planned features

These are part of the intended goal-planning app and have **not** been added yet:

- **Connections across the board** — draw links between related notes so a subject can point to others it depends on or leads into, even on a different level.
- **Difficulty pins** — each note’s pin shows how the topic feels right now: **challenging**, **familiar**, or **confident**.
- **Progress tracking** — see how far the goal has come, including which subjects and levels are underway or finished.
- **Subject notes** — open a note to keep insights, plans, and other writing for that topic, separate from the short title on the board.
- **More than one goal** — keep several pinboards, and start a new goal without wiping the current one.
- **Sync across devices** — saves are local to one phone, emulator, or browser profile today.
- **App identity** — a real display name and icon instead of the Flutter defaults (`preparation_game`, `com.example.preparationGame`).

## Project layout

```
MyPinboard/
└── preparation_game/          Flutter app
    ├── lib/
    │   ├── main.dart          App entry (restores the saved board when present)
    │   ├── screens/           HomePage, ProgressPage
    │   ├── models/            Subject, board snapshot, drag payload
    │   ├── managers/          Board mutations and local storage
    │   ├── UILib/             Pinboard widgets and controls
    │   └── utils/             Fonts, colors, Roman numerals
    ├── assets/
    │   ├── images/            Board, frame, notes, pin, add button
    │   └── fonts/             Amatic SC, Oooh Baby
    └── test/                  Widget tests
```

`ProgressPage` owns the board state (`List<List<Subject>>`: one list of notes per level) and writes it to `shared_preferences` after each change. Widgets under `UILib/` handle presentation and gestures; `BoardManager` filters notes marked for deletion; `BoardStorage` loads and saves a `BoardSnapshot`.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) with Dart **3.11** or newer (`sdk: ^3.11.0` in `pubspec.yaml`)
- A device, emulator, or browser target (`flutter devices`)

The app is generated for **Android, iOS, web, Windows, Linux, and macOS**.

## Getting started

```bash
git clone https://github.com/jagoda-ks/MyPinboard.git
cd MyPinboard/preparation_game
flutter pub get
flutter run
```

Pick a device with `flutter devices`, then for example:

```bash
flutter run -d chrome
flutter run -d windows
```

## Development

```bash
cd preparation_game
flutter analyze
flutter test
```

`flutter_lints` is enabled via `analysis_options.yaml`.

Widget tests cover the home vs restored-board launch paths. Snapshot and storage tests cover save/load.

## Dependencies

| Package | Role |
| --- | --- |
| `flutter` | UI framework |
| `cupertino_icons` | iOS-style icons |
| `google_fonts` | Declared; the UI currently uses bundled fonts instead |
| `shared_preferences` | Local save of the board on each device |

Custom typefaces:

- **CustomFont** — [Amatic SC](https://fonts.google.com/specimen/Amatic+SC) (titles and level labels)
- **CustomFont2** — [Oooh Baby](https://fonts.google.com/specimen/Oooh+Baby) (sticky-note text and the add-subject popup)

Shared colors, text styles, and asset paths live in `lib/utils/settings.dart`.

## Current limits

- Uninstalling the app typically clears the local save.
- Roman numerals are mapped through X; higher level numbers fall back to Arabic digits.

## License

No license file is included in this repository.
