/// A single behavior shrunk to its tiniest form, following BJ Fogg's recipe:
/// "After I [anchor], I will [tiny action]" — then celebrate immediately.
class TinyHabit {
  TinyHabit({
    required this.id,
    required this.domain,
    required this.domainLabel,
    required this.behavior,
    required this.anchorPrompt,
    required this.tinyAction,
    required this.celebration,
    required this.impact,
    required this.ease,
    this.done = false,
    this.reminderHour,
    this.reminderMinute,
  });

  final String id;
  final String domain;
  final String domainLabel;

  /// The full-size behavior this tiny habit grows into.
  final String behavior;

  /// The existing routine the habit is anchored to ("After I ...").
  final String anchorPrompt;

  /// The tiny action, doable in under 30 seconds ("I will ...").
  final String tinyAction;

  /// The immediate celebration that wires the habit in.
  final String celebration;

  /// Impact toward the aspiration, 1-5.
  final int impact;

  /// Feasibility / ease of doing today, 1-5.
  final int ease;

  /// Whether the user has done this habit in the current session.
  bool done;

  /// Hour (0-23) of the daily reminder, or null if no reminder is set.
  int? reminderHour;

  /// Minute (0-59) of the daily reminder, or null if no reminder is set.
  int? reminderMinute;

  /// The Fogg recipe as one readable sentence.
  String get recipe => '$anchorPrompt, $tinyAction.';

  /// High impact AND high feasibility — a Tiny Habits "Golden Behavior".
  bool get isGolden => impact >= 4 && ease >= 4;

  /// Whether a daily reminder is currently scheduled for this habit.
  bool get hasReminder => reminderHour != null && reminderMinute != null;

  /// Stable, non-negative id used to schedule/cancel this habit's
  /// Android notification.
  int get notificationId => id.hashCode & 0x7fffffff;

  Map<String, dynamic> toJson() => {
        'id': id,
        'domain': domain,
        'domainLabel': domainLabel,
        'behavior': behavior,
        'anchorPrompt': anchorPrompt,
        'tinyAction': tinyAction,
        'celebration': celebration,
        'impact': impact,
        'ease': ease,
        'done': done,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
      };

  factory TinyHabit.fromJson(Map<String, dynamic> json) => TinyHabit(
        id: json['id'] as String,
        domain: json['domain'] as String,
        domainLabel: json['domainLabel'] as String,
        behavior: json['behavior'] as String,
        anchorPrompt: json['anchorPrompt'] as String,
        tinyAction: json['tinyAction'] as String,
        celebration: json['celebration'] as String,
        impact: json['impact'] as int,
        ease: json['ease'] as int,
        done: json['done'] as bool? ?? false,
        reminderHour: json['reminderHour'] as int?,
        reminderMinute: json['reminderMinute'] as int?,
      );
}
