import 'package:flutter/material.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';
import 'package:week_organizer/model/repositories/archive_repository.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';
import 'package:week_organizer/utils/archive_scheduler.dart';
import 'package:week_organizer/view/activitiesPage.dart';
import 'package:week_organizer/view/archivePage.dart';
import 'package:week_organizer/view/reccurringPage.dart';

import 'package:week_organizer/model/database.dart';
import 'package:week_organizer/viewmodel/archive_view_model.dart'; // import your Floor db

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;

  ActivityRepository? _activityRepository;
  RecurringActivityRepository? _reccurringActivityRepository;
  ArchiveRepository? _archiveRepository;

  bool _isLoading = true;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkAndRunArchive(context);
  });
  }

  Future<void> _initDatabaseAndRepo() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();

    final activityDao = database.activityDao;
    final reccuringActivityDao = database.reccuringActivityDao;
    final archiveDao = database.archivedActivityDao;
    final rArchiveDao = database.archivedRecurringActivityDao;
    _activityRepository = ActivityRepository(activityDao);
    _reccurringActivityRepository = RecurringActivityRepository(reccuringActivityDao);
    _archiveRepository = ArchiveRepository(archiveDao, rArchiveDao);
    // Initialize widget options now that repository is ready
    _widgetOptions = [
      ActivityPage(repository: _activityRepository!),
      ReccurringPage(repository: _reccurringActivityRepository!),
      ArchivePage(archiveRepository: _archiveRepository!, activityRepository: _activityRepository!, recurringActivityRepository: _reccurringActivityRepository!),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Week organizer"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              //child: const Text('Tab selection'),
              child: const OverflowBox
              (
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Image(image: AssetImage('assets/sprite.png'), height: 60, fit: BoxFit.contain,)),
            ),
            ListTile(
              title: const Text('Daily activities'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reccurring activities'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Archive'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _checkAndRunArchive(BuildContext context) async {
  final shouldRun = await shouldRunWeeklyArchive();
  if (shouldRun) {
    final archiveVM = ArchiveViewModel(_archiveRepository!, _activityRepository!, _reccurringActivityRepository!);
    await archiveVM.runWeeklyArchive();
  }
}
}