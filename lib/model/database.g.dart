// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ActivityDao? _activityDaoInstance;

  RecurringActivityDao? _reccuringActivityDaoInstance;

  ArchivedActivityDao? _archivedActivityDaoInstance;

  ArchivedRecurringActivityDao? _archivedRecurringActivityDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Activity` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `weekday` INTEGER NOT NULL, `status` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecurringActivity` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `suggestedHours` INTEGER NOT NULL, `reportedHours` REAL NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ArchivedActivity` (`id` INTEGER NOT NULL, `originalId` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `weekday` INTEGER NOT NULL, `finalStatus` INTEGER NOT NULL, `weekStartDate` INTEGER NOT NULL, `archivedAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ArchivedRecurringActivity` (`id` INTEGER NOT NULL, `originalId` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `suggestedHours` INTEGER NOT NULL, `reportedHours` REAL NOT NULL, `weekStartDate` INTEGER NOT NULL, `archivedAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ActivityDao get activityDao {
    return _activityDaoInstance ??= _$ActivityDao(database, changeListener);
  }

  @override
  RecurringActivityDao get reccuringActivityDao {
    return _reccuringActivityDaoInstance ??=
        _$RecurringActivityDao(database, changeListener);
  }

  @override
  ArchivedActivityDao get archivedActivityDao {
    return _archivedActivityDaoInstance ??=
        _$ArchivedActivityDao(database, changeListener);
  }

  @override
  ArchivedRecurringActivityDao get archivedRecurringActivityDao {
    return _archivedRecurringActivityDaoInstance ??=
        _$ArchivedRecurringActivityDao(database, changeListener);
  }
}

class _$ActivityDao extends ActivityDao {
  _$ActivityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _activityInsertionAdapter = InsertionAdapter(
            database,
            'Activity',
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'weekday': _weekdayConverter.encode(item.weekday),
                  'status': _statusConverter.encode(item.status)
                }),
        _activityUpdateAdapter = UpdateAdapter(
            database,
            'Activity',
            ['id'],
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'weekday': _weekdayConverter.encode(item.weekday),
                  'status': _statusConverter.encode(item.status)
                }),
        _activityDeletionAdapter = DeletionAdapter(
            database,
            'Activity',
            ['id'],
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'weekday': _weekdayConverter.encode(item.weekday),
                  'status': _statusConverter.encode(item.status)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Activity> _activityInsertionAdapter;

  final UpdateAdapter<Activity> _activityUpdateAdapter;

  final DeletionAdapter<Activity> _activityDeletionAdapter;

  @override
  Future<List<Activity>> findAllActivities() async {
    return _queryAdapter.queryList('SELECT * FROM Activity',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)));
  }

  @override
  Future<Activity?> findActivityById(int id) async {
    return _queryAdapter.query('SELECT * FROM Activity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)),
        arguments: [id]);
  }

  @override
  Future<List<Activity>> findActivitiesByWeekday(Weekday weekday) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE weekday = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)),
        arguments: [_weekdayConverter.encode(weekday)]);
  }

  @override
  Future<List<Activity>> findActivitiesByStatus(Status status) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)),
        arguments: [_statusConverter.encode(status)]);
  }

  @override
  Future<List<Activity>> findActivitiesByWeekdayAndStatus(
    Weekday weekday,
    Status status,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Activity WHERE weekday = ?1 AND status = ?2',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)),
        arguments: [
          _weekdayConverter.encode(weekday),
          _statusConverter.encode(status)
        ]);
  }

  @override
  Future<void> updateActivityStatus(
    int id,
    Status status,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Activity SET status = ?2 WHERE id = ?1',
        arguments: [id, _statusConverter.encode(status)]);
  }

  @override
  Future<void> updateActivitiesStatus(
    Status oldStatus,
    Status newStatus,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Activity SET status = ?2 WHERE status = ?1',
        arguments: [
          _statusConverter.encode(oldStatus),
          _statusConverter.encode(newStatus)
        ]);
  }

  @override
  Future<void> deleteActivityById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Activity WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteActivitiesByStatus(Status status) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Activity WHERE status = ?1',
        arguments: [_statusConverter.encode(status)]);
  }

  @override
  Future<List<Activity>> findCompletedActivities(Status status) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            _statusConverter.decode(row['status'] as int),
            _weekdayConverter.decode(row['weekday'] as int)),
        arguments: [_statusConverter.encode(status)]);
  }

  @override
  Future<void> resetWeeklyActivities(
    Status status,
    Status currentStatus,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Activity SET status = ?1 WHERE status = ?2',
        arguments: [
          _statusConverter.encode(status),
          _statusConverter.encode(currentStatus)
        ]);
  }

  @override
  Future<int?> getCountByStatus(Status status) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Activity WHERE status = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [_statusConverter.encode(status)]);
  }

  @override
  Future<int?> getCountByWeekdayAndStatus(
    Weekday weekday,
    Status status,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Activity WHERE weekday = ?1 AND status = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [
          _weekdayConverter.encode(weekday),
          _statusConverter.encode(status)
        ]);
  }

  @override
  Future<void> insertActivity(Activity activity) async {
    await _activityInsertionAdapter.insert(activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertActivities(List<Activity> activities) async {
    await _activityInsertionAdapter.insertList(
        activities, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    await _activityUpdateAdapter.update(activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteActivity(Activity activity) async {
    await _activityDeletionAdapter.delete(activity);
  }
}

class _$RecurringActivityDao extends RecurringActivityDao {
  _$RecurringActivityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recurringActivityInsertionAdapter = InsertionAdapter(
            database,
            'RecurringActivity',
            (RecurringActivity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'suggestedHours': item.suggestedHours,
                  'reportedHours': item.reportedHours
                }),
        _recurringActivityUpdateAdapter = UpdateAdapter(
            database,
            'RecurringActivity',
            ['id'],
            (RecurringActivity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'suggestedHours': item.suggestedHours,
                  'reportedHours': item.reportedHours
                }),
        _recurringActivityDeletionAdapter = DeletionAdapter(
            database,
            'RecurringActivity',
            ['id'],
            (RecurringActivity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'suggestedHours': item.suggestedHours,
                  'reportedHours': item.reportedHours
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecurringActivity> _recurringActivityInsertionAdapter;

  final UpdateAdapter<RecurringActivity> _recurringActivityUpdateAdapter;

  final DeletionAdapter<RecurringActivity> _recurringActivityDeletionAdapter;

  @override
  Future<List<RecurringActivity>> findAllRecurringActivities() async {
    return _queryAdapter.queryList('SELECT * FROM RecurringActivity',
        mapper: (Map<String, Object?> row) => RecurringActivity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            row['suggestedHours'] as int,
            row['reportedHours'] as double));
  }

  @override
  Future<RecurringActivity?> findRecurringActivityById(int id) async {
    return _queryAdapter.query('SELECT * FROM RecurringActivity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RecurringActivity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            row['suggestedHours'] as int,
            row['reportedHours'] as double),
        arguments: [id]);
  }

  @override
  Future<void> updateReportedHours(
    int id,
    double hours,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE RecurringActivity SET reportedHours = ?2 WHERE id = ?1',
        arguments: [id, hours]);
  }

  @override
  Future<void> resetAllReportedHours() async {
    await _queryAdapter
        .queryNoReturn('UPDATE RecurringActivity SET reportedHours = 0');
  }

  @override
  Future<void> deleteRecurringActivityById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM RecurringActivity WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<RecurringActivity>> findActivitiesWithReportedHours() async {
    return _queryAdapter.queryList(
        'SELECT * FROM RecurringActivity WHERE reportedHours > 0',
        mapper: (Map<String, Object?> row) => RecurringActivity(
            row['id'] as int,
            row['name'] as String,
            row['description'] as String?,
            row['suggestedHours'] as int,
            row['reportedHours'] as double));
  }

  @override
  Future<double?> getTotalReportedHours() async {
    return _queryAdapter.query(
        'SELECT SUM(reportedHours) FROM RecurringActivity',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<int?> getTotalSuggestedHours() async {
    return _queryAdapter.query(
        'SELECT SUM(suggestedHours) FROM RecurringActivity',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertRecurringActivity(RecurringActivity activity) async {
    await _recurringActivityInsertionAdapter.insert(
        activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRecurringActivities(
      List<RecurringActivity> activities) async {
    await _recurringActivityInsertionAdapter.insertList(
        activities, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRecurringActivity(RecurringActivity activity) async {
    await _recurringActivityUpdateAdapter.update(
        activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecurringActivity(RecurringActivity activity) async {
    await _recurringActivityDeletionAdapter.delete(activity);
  }
}

class _$ArchivedActivityDao extends ArchivedActivityDao {
  _$ArchivedActivityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _archivedActivityInsertionAdapter = InsertionAdapter(
            database,
            'ArchivedActivity',
            (ArchivedActivity item) => <String, Object?>{
                  'id': item.id,
                  'originalId': item.originalId,
                  'name': item.name,
                  'description': item.description,
                  'weekday': _weekdayConverter.encode(item.weekday),
                  'finalStatus': _statusConverter.encode(item.finalStatus),
                  'weekStartDate':
                      _dateTimeConverter.encode(item.weekStartDate),
                  'archivedAt': _dateTimeConverter.encode(item.archivedAt)
                }),
        _archivedActivityDeletionAdapter = DeletionAdapter(
            database,
            'ArchivedActivity',
            ['id'],
            (ArchivedActivity item) => <String, Object?>{
                  'id': item.id,
                  'originalId': item.originalId,
                  'name': item.name,
                  'description': item.description,
                  'weekday': _weekdayConverter.encode(item.weekday),
                  'finalStatus': _statusConverter.encode(item.finalStatus),
                  'weekStartDate':
                      _dateTimeConverter.encode(item.weekStartDate),
                  'archivedAt': _dateTimeConverter.encode(item.archivedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ArchivedActivity> _archivedActivityInsertionAdapter;

  final DeletionAdapter<ArchivedActivity> _archivedActivityDeletionAdapter;

  @override
  Future<List<ArchivedActivity>> findAllArchivedActivities() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedActivity ORDER BY archivedAt DESC',
        mapper: (Map<String, Object?> row) => ArchivedActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            _weekdayConverter.decode(row['weekday'] as int),
            _statusConverter.decode(row['finalStatus'] as int),
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)));
  }

  @override
  Future<List<ArchivedActivity>> findByWeekStartDate(
      DateTime weekStartDate) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedActivity WHERE weekStartDate = ?1',
        mapper: (Map<String, Object?> row) => ArchivedActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            _weekdayConverter.decode(row['weekday'] as int),
            _statusConverter.decode(row['finalStatus'] as int),
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [_dateTimeConverter.encode(weekStartDate)]);
  }

  @override
  Future<List<ArchivedActivity>> findByOriginalId(int originalId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedActivity WHERE originalId = ?1 ORDER BY archivedAt DESC',
        mapper: (Map<String, Object?> row) => ArchivedActivity(row['id'] as int, row['originalId'] as int, row['name'] as String, row['description'] as String?, _weekdayConverter.decode(row['weekday'] as int), _statusConverter.decode(row['finalStatus'] as int), _dateTimeConverter.decode(row['weekStartDate'] as int), _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [originalId]);
  }

  @override
  Future<List<ArchivedActivity>> findByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedActivity WHERE weekStartDate BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => ArchivedActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            _weekdayConverter.decode(row['weekday'] as int),
            _statusConverter.decode(row['finalStatus'] as int),
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [
          _dateTimeConverter.encode(startDate),
          _dateTimeConverter.encode(endDate)
        ]);
  }

  @override
  Future<List<ArchivedActivity>> findByFinalStatus(Status status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedActivity WHERE finalStatus = ?1',
        mapper: (Map<String, Object?> row) => ArchivedActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            _weekdayConverter.decode(row['weekday'] as int),
            _statusConverter.decode(row['finalStatus'] as int),
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [_statusConverter.encode(status)]);
  }

  @override
  Future<void> deleteOldArchives(DateTime cutoffDate) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ArchivedActivity WHERE weekStartDate < ?1',
        arguments: [_dateTimeConverter.encode(cutoffDate)]);
  }

  @override
  Future<int?> getCompletionCountForWeek(
    DateTime weekStartDate,
    Status status,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ArchivedActivity WHERE weekStartDate = ?1 AND finalStatus = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [
          _dateTimeConverter.encode(weekStartDate),
          _statusConverter.encode(status)
        ]);
  }

  @override
  Future<List<DateTime>> getAvailableWeeks() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT weekStartDate FROM ArchivedActivity ORDER BY weekStartDate DESC',
        mapper: (Map<String, Object?> row) =>
            _dateTimeConverter.decode(row.values.first as int));
  }

  @override
  Future<double?> getCompletionRateForActivity(
    int originalId,
    Status completedStatus,
  ) async {
    return _queryAdapter.query(
        'SELECT AVG(CASE WHEN finalStatus = ?2 THEN 1.0 ELSE 0.0 END) FROM ArchivedActivity WHERE originalId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [originalId, _statusConverter.encode(completedStatus)]);
  }

  @override
  Future<void> insertArchivedActivity(ArchivedActivity activity) async {
    await _archivedActivityInsertionAdapter.insert(
        activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertArchivedActivities(
      List<ArchivedActivity> activities) async {
    await _archivedActivityInsertionAdapter.insertList(
        activities, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteArchivedActivity(ArchivedActivity activity) async {
    await _archivedActivityDeletionAdapter.delete(activity);
  }
}

class _$ArchivedRecurringActivityDao extends ArchivedRecurringActivityDao {
  _$ArchivedRecurringActivityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _archivedRecurringActivityInsertionAdapter = InsertionAdapter(
            database,
            'ArchivedRecurringActivity',
            (ArchivedRecurringActivity item) => <String, Object?>{
                  'id': item.id,
                  'originalId': item.originalId,
                  'name': item.name,
                  'description': item.description,
                  'suggestedHours': item.suggestedHours,
                  'reportedHours': item.reportedHours,
                  'weekStartDate':
                      _dateTimeConverter.encode(item.weekStartDate),
                  'archivedAt': _dateTimeConverter.encode(item.archivedAt)
                }),
        _archivedRecurringActivityDeletionAdapter = DeletionAdapter(
            database,
            'ArchivedRecurringActivity',
            ['id'],
            (ArchivedRecurringActivity item) => <String, Object?>{
                  'id': item.id,
                  'originalId': item.originalId,
                  'name': item.name,
                  'description': item.description,
                  'suggestedHours': item.suggestedHours,
                  'reportedHours': item.reportedHours,
                  'weekStartDate':
                      _dateTimeConverter.encode(item.weekStartDate),
                  'archivedAt': _dateTimeConverter.encode(item.archivedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ArchivedRecurringActivity>
      _archivedRecurringActivityInsertionAdapter;

  final DeletionAdapter<ArchivedRecurringActivity>
      _archivedRecurringActivityDeletionAdapter;

  @override
  Future<List<ArchivedRecurringActivity>>
      findAllArchivedRecurringActivities() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedRecurringActivity ORDER BY archivedAt DESC',
        mapper: (Map<String, Object?> row) => ArchivedRecurringActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            row['suggestedHours'] as int,
            row['reportedHours'] as double,
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)));
  }

  @override
  Future<List<ArchivedRecurringActivity>> findByWeekStartDate(
      DateTime weekStartDate) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedRecurringActivity WHERE weekStartDate = ?1',
        mapper: (Map<String, Object?> row) => ArchivedRecurringActivity(
            row['id'] as int,
            row['originalId'] as int,
            row['name'] as String,
            row['description'] as String?,
            row['suggestedHours'] as int,
            row['reportedHours'] as double,
            _dateTimeConverter.decode(row['weekStartDate'] as int),
            _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [_dateTimeConverter.encode(weekStartDate)]);
  }

  @override
  Future<List<ArchivedRecurringActivity>> findByOriginalId(
      int originalId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedRecurringActivity WHERE originalId = ?1 ORDER BY archivedAt DESC',
        mapper: (Map<String, Object?> row) => ArchivedRecurringActivity(row['id'] as int, row['originalId'] as int, row['name'] as String, row['description'] as String?, row['suggestedHours'] as int, row['reportedHours'] as double, _dateTimeConverter.decode(row['weekStartDate'] as int), _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [originalId]);
  }

  @override
  Future<List<ArchivedRecurringActivity>> findByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ArchivedRecurringActivity WHERE weekStartDate BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => ArchivedRecurringActivity(row['id'] as int, row['originalId'] as int, row['name'] as String, row['description'] as String?, row['suggestedHours'] as int, row['reportedHours'] as double, _dateTimeConverter.decode(row['weekStartDate'] as int), _dateTimeConverter.decode(row['archivedAt'] as int)),
        arguments: [
          _dateTimeConverter.encode(startDate),
          _dateTimeConverter.encode(endDate)
        ]);
  }

  @override
  Future<void> deleteOldArchives(DateTime cutoffDate) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ArchivedRecurringActivity WHERE weekStartDate < ?1',
        arguments: [_dateTimeConverter.encode(cutoffDate)]);
  }

  @override
  Future<double?> getTotalReportedHoursForWeek(DateTime weekStartDate) async {
    return _queryAdapter.query(
        'SELECT SUM(reportedHours) FROM ArchivedRecurringActivity WHERE weekStartDate = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [_dateTimeConverter.encode(weekStartDate)]);
  }

  @override
  Future<double?> getAverageReportedHoursForActivity(int originalId) async {
    return _queryAdapter.query(
        'SELECT AVG(reportedHours) FROM ArchivedRecurringActivity WHERE originalId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [originalId]);
  }

  @override
  Future<List<DateTime>> getAvailableWeeks() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT weekStartDate FROM ArchivedRecurringActivity ORDER BY weekStartDate DESC',
        mapper: (Map<String, Object?> row) =>
            _dateTimeConverter.decode(row.values.first as int));
  }

  @override
  Future<void> insertArchivedRecurringActivity(
      ArchivedRecurringActivity activity) async {
    await _archivedRecurringActivityInsertionAdapter.insert(
        activity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertArchivedRecurringActivities(
      List<ArchivedRecurringActivity> activities) async {
    await _archivedRecurringActivityInsertionAdapter.insertList(
        activities, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteArchivedRecurringActivity(
      ArchivedRecurringActivity activity) async {
    await _archivedRecurringActivityDeletionAdapter.delete(activity);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _statusConverter = StatusConverter();
final _weekdayConverter = WeekdayConverter();
