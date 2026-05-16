import 'package:flutter/material.dart';

import 'models/habit_map.dart';
import 'screens/aspiration_screen.dart';
import 'screens/habit_map_screen.dart';
import 'services/habit_storage.dart';

void main() {
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
  }

  Future<void> _loadSavedMap() async {
    final map = await _storage.load();
    if (!mounted) return;
    setState(() {
      _map = map;
      _loading = false;
    });
  }

  Future<void> _persist(HabitMap map) async {
    setState(() => _map = map);
    await _storage.save(map);
  }

  Future<void> _reset() async {
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
