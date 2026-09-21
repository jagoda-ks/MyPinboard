import 'dart:convert';

import 'package:preparation_game/models/board_snapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardStorage {
  static const storageKey = 'pinboard.board.v1';

  Future<BoardSnapshot?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return BoardSnapshot.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(BoardSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(snapshot.toJson()));
  }
}
