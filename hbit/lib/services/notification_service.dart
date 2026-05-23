import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/tiny_habit.dart';

/// Schedules on-device daily reminders for tiny habits.
///
/// These are local notifications timed by the device clock — there is no
/// remote push / Firebase involved. They are scheduled with [alarmClock]
/// mode so they fire at the exact time even when the device is in Doze.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'hbit_habit_reminders';
  static const String _channelName = 'Habit reminders';
  static const String _channelDescription =
      'Daily reminders for your tiny habits';

  /// Notification id for the one-off "test" reminder.
  static const int _testId = 990001;

  bool _ready = false;

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  /// Loads timezone data and initializes the plugin. Safe to call repeatedly.
  Future<void> init() async {
    if (_ready) return;

    tz.initializeTimeZones();
    try {
      final localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone.identifier));
    } catch (_) {
      // Fall back to UTC if the device timezone can't be resolved.
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Create the channel up front so a reminder that fires while the app
    // process is dead always has a valid channel to post to.
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    _ready = true;
  }

  /// Asks for the permissions reminders need: posting notifications
  /// (Android 13+) and scheduling exact alarms. Returns true when reminders
  /// can be shown.
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;

    final canPost = await android.requestNotificationsPermission() ?? true;
    // Harmless if USE_EXACT_ALARM is already granting exact alarms.
    await android.requestExactAlarmsPermission();
    return canPost;
  }

  /// Schedules (or reschedules) a daily reminder for [habit]. Returns the
  /// date/time the next notification will fire.
  Future<DateTime> scheduleReminder(TinyHabit habit) async {
    await init();
    final next = _nextInstanceOf(habit.reminderHour!, habit.reminderMinute!);

    await _plugin.zonedSchedule(
      id: habit.notificationId,
      title: habit.behavior,
      body: habit.recipe,
      scheduledDate: next,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    return DateTime(next.year, next.month, next.day, next.hour, next.minute);
  }

  /// Cancels the reminder for a single habit.
  Future<void> cancelReminder(TinyHabit habit) async {
    await init();
    await _plugin.cancel(id: habit.notificationId);
  }

  /// Cancels every scheduled reminder — used when the map is reset.
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Re-applies the schedule for a whole list of habits, e.g. on app start
  /// so reminders stay in sync with the saved map.
  Future<void> syncAll(List<TinyHabit> habits) async {
    await init();
    for (final habit in habits) {
      if (habit.hasReminder) {
        await scheduleReminder(habit);
      } else {
        await _plugin.cancel(id: habit.notificationId);
      }
    }
  }

  /// Schedules a one-off notification ~10 seconds out, so the user can
  /// verify that scheduled reminders actually fire on their device.
  Future<void> sendTestReminder() async {
    await init();
    await _plugin.zonedSchedule(
      id: _testId,
      title: 'Hbit test reminder',
      body: 'Scheduled reminders are working — this fired about 10 seconds '
          'after you tapped Test.',
      scheduledDate:
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  /// The next occurrence of [hour]:[minute], today if still ahead else
  /// tomorrow. [matchDateTimeComponents] then repeats it every day.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
