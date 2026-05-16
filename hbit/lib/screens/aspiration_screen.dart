import 'package:flutter/material.dart';

import '../engine/habit_engine.dart';
import '../models/aspiration.dart';
import '../models/habit_map.dart';

/// Step 1 of the Tiny Habits flow: ask the user what they want to become.
class AspirationScreen extends StatefulWidget {
  const AspirationScreen({super.key, required this.onGenerated});

  final ValueChanged<HabitMap> onGenerated;

  @override
  State<AspirationScreen> createState() => _AspirationScreenState();
}

class _AspirationScreenState extends State<AspirationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _timeframeController = TextEditingController(text: '3 years');
  final _motivationController = TextEditingController();

  @override
  void dispose() {
    _identityController.dispose();
    _timeframeController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  void _generate() {
    if (!_formKey.currentState!.validate()) return;

    final aspiration = Aspiration(
      identity: _identityController.text.trim(),
      timeframe: _timeframeController.text.trim().isEmpty
          ? '3 years'
          : _timeframeController.text.trim(),
      motivation: _motivationController.text.trim(),
      createdAt: DateTime.now(),
    );

    widget.onGenerated(HabitEngine.generate(aspiration));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Aspiration'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Build your career habit map',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on BJ Fogg\'s Tiny Habits. Tell us your ultimate '
                  'goal and we\'ll break it into tiny, anchored habits you '
                  'can actually keep.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 28),
                _FieldLabel('What do you want to become?'),
                TextFormField(
                  controller: _identityController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. a senior engineering leader',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Tell us the role or identity you\'re aiming for'
                          : null,
                ),
                const SizedBox(height: 20),
                _FieldLabel('By when?'),
                TextFormField(
                  controller: _timeframeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 3 years, 18 months',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _FieldLabel('Why does this matter to you?'),
                TextFormField(
                  controller: _motivationController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'The deeper reason behind the goal. '
                        'Be specific — it helps us pick the right habits.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Your motivation anchors the whole map'
                          : null,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _generate,
                  icon: const Icon(Icons.auto_awesome),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  label: const Text('Generate my habit map'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
