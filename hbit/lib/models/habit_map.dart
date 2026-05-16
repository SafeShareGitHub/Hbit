import 'aspiration.dart';
import 'tiny_habit.dart';

/// A generated Tiny Habits map: one aspiration plus the set of tiny habits
/// the engine selected to move the user toward it.
class HabitMap {
  const HabitMap({required this.aspiration, required this.habits});

  final Aspiration aspiration;
  final List<TinyHabit> habits;

  int get doneCount => habits.where((h) => h.done).length;

  /// Habits grouped by domain label, preserving the engine's ordering.
  Map<String, List<TinyHabit>> get habitsByDomain {
    final grouped = <String, List<TinyHabit>>{};
    for (final habit in habits) {
      grouped.putIfAbsent(habit.domainLabel, () => []).add(habit);
    }
    return grouped;
  }

  Map<String, dynamic> toJson() => {
        'aspiration': aspiration.toJson(),
        'habits': habits.map((h) => h.toJson()).toList(),
      };

  factory HabitMap.fromJson(Map<String, dynamic> json) => HabitMap(
        aspiration:
            Aspiration.fromJson(json['aspiration'] as Map<String, dynamic>),
        habits: (json['habits'] as List)
            .map((e) => TinyHabit.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
