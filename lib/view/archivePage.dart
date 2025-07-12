import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:week_organizer/model/repositories/archive_repository.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';
import 'package:week_organizer/viewmodel/archive_view_model.dart';


class ArchivePage extends StatefulWidget {
  final ArchiveRepository archiveRepository;
  final ActivityRepository activityRepository;
  final RecurringActivityRepository recurringActivityRepository;

  const ArchivePage({
    super.key,
    required this.archiveRepository,
    required this.activityRepository,
    required this.recurringActivityRepository,
  });

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late ArchiveViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ArchiveViewModel(
      widget.archiveRepository,
      widget.activityRepository,
      widget.recurringActivityRepository,
    );
    _viewModel.loadArchiveData();
  }

  String formatDate(DateTime date) => DateFormat.yMMMMd().format(date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<ArchiveViewModel>.value(
      value: _viewModel,
      child: Consumer<ArchiveViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Scaffold(
              appBar: AppBar(title: Text("Archive", style: theme.textTheme.titleLarge)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (vm.groupedByWeek.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text("Archive", style: theme.textTheme.titleLarge)),
              body: Center(child: Text("No archived items", style: theme.textTheme.bodyMedium)),
            );
          }

          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              title: Text("Archive", style: theme.textTheme.titleLarge),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.archive),
                  tooltip: 'Archive Current Week',
                  onPressed: () async {
                    final now = DateTime.now();
                    final weekStart = DateTime(now.year, now.month, now.day - now.weekday + 1);
                    await vm.archiveCurrentWeek(weekStart);
                  },
                ),
              ],
            ),
            body: ListView(
              children: vm.groupedByWeek.entries.map((entry) {
                final date = entry.key;
                final rec = entry.value['recurring'] ?? [];
                final act = entry.value['activities'] ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: theme.cardColor,
                  child: ExpansionTile(
                    title: Text("Week of ${formatDate(date)}", style: theme.textTheme.titleMedium),
                    children: [
                      if (rec.isEmpty && act.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No archived items", style: theme.textTheme.bodyMedium),
                        ),
                      ...rec.map((item) => ListTile(
                            title: Text(item.name, style: theme.textTheme.bodyLarge),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.description != null)
                                  Text(item.description!, style: theme.textTheme.bodyMedium),
                                Text(
                                  "Reported: ${item.reportedHours}/${item.suggestedHours} hrs",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )),
                      ...act.map((item) => ListTile(
                            title: Text(item.name, style: theme.textTheme.bodyLarge),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.description != null)
                                  Text(item.description!, style: theme.textTheme.bodyMedium),
                                Text(
                                  "Status: ${item.finalStatus.toString().split('.').last}",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
