/// The user's ultimate career goal, captured in the Tiny Habits language of
/// an "aspiration": an abstract outcome the habit map is designed to serve.
class Aspiration {
  const Aspiration({
    required this.identity,
    required this.timeframe,
    required this.motivation,
    required this.createdAt,
  });

  /// What the user wants to become, e.g. "a senior engineering leader".
  final String identity;

  /// Free-text horizon, e.g. "3 years" or "18 months".
  final String timeframe;

  /// Why the goal matters to the user. Used to match relevant behaviors.
  final String motivation;

  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'identity': identity,
        'timeframe': timeframe,
        'motivation': motivation,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Aspiration.fromJson(Map<String, dynamic> json) => Aspiration(
        identity: json['identity'] as String,
        timeframe: json['timeframe'] as String,
        motivation: json['motivation'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
