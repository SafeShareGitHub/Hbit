import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit_map.dart';

/// Persists the user's habit map locally so it survives app restarts.
class HabitStorage {
  static const String _key = 'hbit.habit_map.v1';

  Future<HabitMap?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return HabitMap.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or outdated data — drop it and start fresh.
      await prefs.remove(_key);
      return null;
    }
  }

  Future<void> save(HabitMap map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(map.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
