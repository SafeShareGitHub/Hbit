import '../data/behavior_library.dart';
import '../models/aspiration.dart';
import '../models/habit_map.dart';
import '../models/tiny_habit.dart';

/// The Tiny Habits rule engine.
///
/// It turns an [Aspiration] into a [HabitMap] by following BJ Fogg's method:
///   1. Match the aspiration text to relevant career domains.
///   2. Pull candidate behaviors from those domains ("Magic Wanding").
///   3. Rank by Golden Behavior score (impact x feasibility).
///   4. Always fold in universal growth foundations.
class HabitEngine {
  const HabitEngine._();

  static HabitMap generate(Aspiration aspiration) {
    final text =
        '${aspiration.identity} ${aspiration.motivation}'.toLowerCase();

    final domainScores = <String, int>{};
    kDomainKeywords.forEach((domain, keywords) {
      var score = 0;
      for (final keyword in keywords) {
        if (text.contains(keyword)) score++;
      }
      if (score > 0) domainScores[domain] = score;
    });

    final focusDomains = domainScores.keys.toList()
      ..sort((a, b) => domainScores[b]!.compareTo(domainScores[a]!));
    final selectedDomains = focusDomains.take(3).toList();

    final domainQuota = _domainQuota(aspiration.timeframe);

    final domainPool = kBehaviorLibrary
        .where((b) => selectedDomains.contains(b.domain))
        .toList()
      ..sort((a, b) => _golden(b).compareTo(_golden(a)));

    final universalPool = kBehaviorLibrary
        .where((b) => b.domain == kUniversalDomain)
        .toList()
      ..sort((a, b) => _golden(b).compareTo(_golden(a)));

    // With no domain match we lean entirely on the universal foundations.
    final universalQuota = selectedDomains.isEmpty ? universalPool.length : 3;

    final selected = <BehaviorTemplate>[
      ...domainPool.take(domainQuota),
      ...universalPool.take(universalQuota),
    ];

    final habits = <TinyHabit>[];
    for (var i = 0; i < selected.length; i++) {
      final template = selected[i];
      habits.add(
        TinyHabit(
          id: '${template.domain}-$i',
          domain: template.domain,
          domainLabel: kDomainLabels[template.domain] ?? template.domain,
          behavior: template.behavior,
          anchorPrompt: template.anchorPrompt,
          tinyAction: template.tinyAction,
          celebration: template.celebration,
          impact: template.impact,
          ease: template.ease,
        ),
      );
    }

    return HabitMap(aspiration: aspiration, habits: habits);
  }

  static int _golden(BehaviorTemplate b) => b.impact * b.ease;

  /// How many domain-specific habits to include, scaled by the user's
  /// horizon: a shorter horizon keeps the map tight and focused.
  static int _domainQuota(String timeframe) {
    final years = _parseYears(timeframe);
    if (years <= 1) return 4;
    if (years <= 4) return 5;
    return 6;
  }

  static int _parseYears(String timeframe) {
    final lower = timeframe.toLowerCase();
    final match = RegExp(r'\d+').firstMatch(lower);
    if (match == null) return 3;
    final value = int.tryParse(match.group(0)!) ?? 3;
    if (lower.contains('month')) {
      return (value / 12).ceil().clamp(1, 99);
    }
    return value.clamp(1, 99);
  }
}
