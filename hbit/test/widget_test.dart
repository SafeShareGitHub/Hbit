import 'package:flutter_test/flutter_test.dart';

import 'package:hbit/engine/habit_engine.dart';
import 'package:hbit/models/aspiration.dart';
import 'package:hbit/models/habit_map.dart';

void main() {
  Aspiration aspirationFor(String identity, String motivation,
          [String timeframe = '3 years']) =>
      Aspiration(
        identity: identity,
        timeframe: timeframe,
        motivation: motivation,
        createdAt: DateTime(2026),
      );

  test('engine matches domain keywords and always adds growth habits', () {
    final map = HabitEngine.generate(
      aspirationFor('a senior software engineer',
          'I want to build great products and lead a team'),
    );

    expect(map.habits, isNotEmpty);
    expect(map.habits.any((h) => h.domain == 'engineering'), isTrue);
    expect(map.habits.any((h) => h.domain == 'growth'), isTrue);
  });

  test('engine falls back to growth foundations with no domain match', () {
    final map = HabitEngine.generate(
      aspirationFor('a happier person', 'I want more balance in my life'),
    );

    expect(map.habits, isNotEmpty);
    expect(map.habits.every((h) => h.domain == 'growth'), isTrue);
  });

  test('shorter horizon produces a tighter map', () {
    const identity = 'a senior engineering leader';
    const motivation =
        'I want to manage a team and one day found my own startup';

    final short =
        HabitEngine.generate(aspirationFor(identity, motivation, '1 year'));
    final long =
        HabitEngine.generate(aspirationFor(identity, motivation, '10 years'));

    expect(short.habits.length, lessThan(long.habits.length));
  });

  test('habit map survives a JSON round-trip', () {
    final original = HabitEngine.generate(
      aspirationFor('a technical writer', 'I want to publish a book'),
    );
    original.habits.first.done = true;

    final restored = HabitMap.fromJson(original.toJson());

    expect(restored.habits.length, original.habits.length);
    expect(restored.habits.first.done, isTrue);
    expect(restored.aspiration.identity, 'a technical writer');
  });
}
