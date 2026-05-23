import 'package:flutter/material.dart';

import '../models/habit_map.dart';
import '../models/tiny_habit.dart';
import '../services/notification_service.dart';

/// Step 2 of the Tiny Habits flow: the generated habit map.
class HabitMapScreen extends StatelessWidget {
  const HabitMapScreen({
    super.key,
    required this.habitMap,
    required this.onChanged,
    required this.onReset,
  });

  final HabitMap habitMap;

  /// Called after a habit is toggled, so the parent can persist the change.
  final ValueChanged<HabitMap> onChanged;

  /// Called when the user wants to start over with a new aspiration.
  final VoidCallback onReset;

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start a new map?'),
        content: const Text(
          'This clears your current aspiration and habits, cancels all '
          'reminders, then lets you enter a new goal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('New map'),
          ),
        ],
      ),
    );
    if (confirmed == true) onReset();
  }

  /// Asks for permission, picks a time, and schedules a daily reminder.
  Future<void> _editReminder(BuildContext context, TinyHabit habit) async {
    final messenger = ScaffoldMessenger.of(context);
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications are off. Enable them in system settings to '
            'get habit reminders.',
          ),
        ),
      );
      return;
    }
    if (!context.mounted) return;

    final initial = habit.hasReminder
        ? TimeOfDay(hour: habit.reminderHour!, minute: habit.reminderMinute!)
        : const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'Remind me daily at',
    );
    if (picked == null) return;

    habit.reminderHour = picked.hour;
    habit.reminderMinute = picked.minute;
    final next = await NotificationService.instance.scheduleReminder(habit);
    onChanged(habitMap);

    final time = '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
    final when =
        DateUtils.isSameDay(next, DateTime.now()) ? 'today' : 'tomorrow';
    messenger.showSnackBar(
      SnackBar(content: Text('Reminder set — first one fires $when at $time.')),
    );
  }

  Future<void> _sendTest(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications are off. Enable them in system settings first.',
          ),
        ),
      );
      return;
    }
    await NotificationService.instance.sendTestReminder();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Test reminder scheduled — watch for it in ~10 seconds.'),
      ),
    );
  }

  Future<void> _clearReminder(TinyHabit habit) async {
    await NotificationService.instance.cancelReminder(habit);
    habit.reminderHour = null;
    habit.reminderMinute = null;
    onChanged(habitMap);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grouped = habitMap.habitsByDomain;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habit Map'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Send a test reminder',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () => _sendTest(context),
          ),
          IconButton(
            tooltip: 'New map',
            icon: const Icon(Icons.refresh),
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _AspirationCard(habitMap: habitMap),
            const SizedBox(height: 20),
            Text(
              'Your tiny habits',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Each habit is anchored to a routine you already have. Do the '
              'tiny version, then celebrate immediately. Tap the alarm to get '
              'a daily reminder.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            for (final entry in grouped.entries) ...[
              _DomainHeader(label: entry.key, count: entry.value.length),
              for (final habit in entry.value)
                _HabitCard(
                  habit: habit,
                  onToggle: () {
                    habit.done = !habit.done;
                    onChanged(habitMap);
                  },
                  onEditReminder: () => _editReminder(context, habit),
                  onClearReminder: () => _clearReminder(habit),
                ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _AspirationCard extends StatelessWidget {
  const _AspirationCard({required this.habitMap});

  final HabitMap habitMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aspiration = habitMap.aspiration;
    final total = habitMap.habits.length;
    final done = habitMap.doneCount;

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I AM BECOMING',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              aspiration.identity,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.flag_outlined,
                    size: 16, color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(width: 6),
                Text(
                  'Horizon: ${aspiration.timeframe}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '"${aspiration.motivation}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surface.withValues(
                  alpha: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$done of $total habits done today',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainHeader extends StatelessWidget {
  const _DomainHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.habit,
    required this.onToggle,
    required this.onEditReminder,
    required this.onClearReminder,
  });

  final TinyHabit habit;
  final VoidCallback onToggle;
  final VoidCallback onEditReminder;
  final VoidCallback onClearReminder;

  String get _reminderLabel {
    final h = habit.reminderHour!.toString().padLeft(2, '0');
    final m = habit.reminderMinute!.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: habit.done,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          habit.behavior,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: habit.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (habit.isGolden) const _GoldenBadge(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      habit.recipe,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.celebration_outlined,
                            size: 15,
                            color: theme.colorScheme.tertiary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Celebrate: ${habit.celebration}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ReminderRow(
                      hasReminder: habit.hasReminder,
                      label: habit.hasReminder ? _reminderLabel : null,
                      onEdit: onEditReminder,
                      onClear: onClearReminder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The reminder control shown at the bottom of each habit card.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.hasReminder,
    required this.label,
    required this.onEdit,
    required this.onClear,
  });

  final bool hasReminder;
  final String? label;
  final VoidCallback onEdit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!hasReminder) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.add_alarm, size: 18),
          label: const Text('Add daily reminder'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: VisualDensity.compact,
          ),
        ),
      );
    }

    return Row(
      children: [
        ActionChip(
          avatar: Icon(Icons.alarm,
              size: 16, color: theme.colorScheme.onSecondaryContainer),
          label: Text('Daily at $label'),
          backgroundColor: theme.colorScheme.secondaryContainer,
          side: BorderSide.none,
          onPressed: onEdit,
        ),
        IconButton(
          tooltip: 'Remove reminder',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close, size: 18),
          onPressed: onClear,
        ),
      ],
    );
  }
}

class _GoldenBadge extends StatelessWidget {
  const _GoldenBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star,
              size: 12, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 3),
          Text(
            'Golden',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
