import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';
import 'package:week_organizer/viewmodel/reccurring_activity_view_model.dart';


class ReccurringPage extends StatelessWidget {
  final RecurringActivityRepository repository;

  const ReccurringPage({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecurringActivityViewModel>(
      create: (_) => RecurringActivityViewModel(repository),
      child: const RecurringActivityView(),
    );
  }
}

class RecurringActivityView extends StatefulWidget {
  const RecurringActivityView({Key? key}) : super(key: key);

  @override
  State<RecurringActivityView> createState() => _RecurringActivityViewState();
}

class _RecurringActivityViewState extends State<RecurringActivityView> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _showAddActivityDialog(RecurringActivityViewModel vm) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final suggestedHoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New Activity', style: Theme.of(context).textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description (optional)')),
              const SizedBox(height: 12),
              TextField(
                controller: suggestedHoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Suggested Hours'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Add'),
            onPressed: () async {
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();
              final hours = int.tryParse(suggestedHoursController.text.trim());

              if (name.isNotEmpty && hours != null) {
                // ID 0 or null, DB should generate ID
                final newActivity = RecurringActivity(null, name, description.isEmpty ? null : description, hours, 0);
                await vm.addActivity(newActivity);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecurringActivityViewModel>(context);
    final theme = Theme.of(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text("Recurring Activities", style: theme.textTheme.titleLarge),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView.builder(
        itemCount: vm.activities.length,
        itemBuilder: (context, index) {
          final activity = vm.activities[index];
          _controllers.putIfAbsent(activity.id!, () => TextEditingController());

          return Card(
            margin: const EdgeInsets.all(8),
            color: theme.cardColor,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: Text(activity.name, style: theme.textTheme.titleMedium),
              subtitle: Text(
                'Reported: ${activity.reportedHours}h / Suggested: ${activity.suggestedHours}h',
                style: theme.textTheme.bodyMedium,
              ),
              children: [
                if (activity.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(activity.description!, style: theme.textTheme.bodyLarge),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[activity.id],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: "Add hours"),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: theme.colorScheme.primary),
                        onPressed: () async {
                          final input = _controllers[activity.id]?.text ?? '';
                          final added = double.tryParse(input);
                          if (added != null) {
                            await vm.addHours(activity.id!, added);
                            _controllers[activity.id]?.clear();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: theme.colorScheme.error),
                        onPressed: () async {
                          await vm.deleteActivity(activity);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityDialog(vm),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
