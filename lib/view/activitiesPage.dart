import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';
import 'package:week_organizer/viewmodel/activity_view_model.dart';

class ActivityPage extends StatelessWidget {
  final ActivityRepository repository;

  const ActivityPage({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityViewModel>(
      create: (_) {
        final vm = ActivityViewModel(repository);
        vm.loadActivities(); // load activities when provider is created
        return vm;
      },
      child: const _ActivityPageBody(),
    );
  }
}

class _ActivityPageBody extends StatelessWidget {
  const _ActivityPageBody({Key? key}) : super(key: key);

  void _showAddActivityDialog(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.read<ActivityViewModel>();

    String name = '';
    String? description;
    Weekday selectedDay = Weekday.MONDAY;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Activity", style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (val) => name = val,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (val) => description = val,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Weekday>(
              value: selectedDay,
              decoration: const InputDecoration(labelText: "Weekday"),
              items: Weekday.values
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(vm.weekdayToString(day)),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedDay = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: theme.textTheme.labelLarge),
          ),
          ElevatedButton(
            onPressed: () async {
              if (name.trim().isEmpty) return;
              await vm.addActivity(name, description, selectedDay);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ActivityViewModel>(
      builder: (context, vm, _) {
        final grouped = vm.groupedActivities;

        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            title: Text("Weekly Activities", style: theme.textTheme.titleLarge),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          body: ListView(
            children: Weekday.values.map((day) {
              final activities = grouped[day] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: theme.cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  initiallyExpanded: vm.expanded[day] ?? false,
                  onExpansionChanged: (val) {
                    vm.toggleExpanded(day, val);
                  },
                  title: Text(vm.weekdayToString(day), style: theme.textTheme.titleMedium),
                  children: activities.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("No activities", style: theme.textTheme.bodyMedium),
                          )
                        ]
                      : activities.map((activity) {
                          return ListTile(
                            title: Text(activity.name, style: theme.textTheme.bodyLarge),
                            subtitle: activity.description != null
                                ? Text(activity.description!, style: theme.textTheme.bodyMedium)
                                : null,
                            trailing: activity.status == Status.UNFINISHED
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await vm.markActivityCompleted(activity);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: theme.colorScheme.onPrimary,
                                    ),
                                    child: const Text("Mark Done"),
                                  )
                                : Chip(
                                    label: Text(activity.status.name),
                                    backgroundColor: vm.statusColor(activity.status, context),
                                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                                  ),
                          );
                        }).toList(),
                ),
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddActivityDialog(context),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
