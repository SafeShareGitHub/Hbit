import 'package:flutter/material.dart';

import 'models/habit_map.dart';
import 'screens/aspiration_screen.dart';
import 'screens/habit_map_screen.dart';
import 'services/habit_storage.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const HbitApp());
}

class HbitApp extends StatelessWidget {
  const HbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hbit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}

/// Decides which screen to show based on whether a saved map exists, and
/// owns persistence so the screens stay simple.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final HabitStorage _storage = HabitStorage();
  bool _loading = true;
  HabitMap? _map;

  @override
  void initState() {
    super.initState();
    _loadSavedMap();
    // Ask for notification permission once, after the first frame. Android
    // only surfaces the system dialog once, so calling it on every start is
    // harmless if the user has already answered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.requestPermission();
    });
  }

  Future<void> _loadSavedMap() async {
    final map = await _storage.load();
    if (!mounted) return;
    setState(() {
      _map = map;
      _loading = false;
    });
    // Keep scheduled reminders in sync with the saved map.
    if (map != null) {
      await NotificationService.instance.syncAll(map.habits);
    }
  }

  Future<void> _persist(HabitMap map) async {
    setState(() => _map = map);
    await _storage.save(map);
  }

  Future<void> _reset() async {
    await NotificationService.instance.cancelAll();
    setState(() => _map = null);
    await _storage.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final map = _map;
    if (map == null) {
      return AspirationScreen(onGenerated: _persist);
    }

    return HabitMapScreen(
      habitMap: map,
      onChanged: _persist,
      onReset: _reset,
    );
  }
}
