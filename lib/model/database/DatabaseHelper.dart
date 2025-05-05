import 'package:floor/floor.dart';

import 'ChaatBarDatabase.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static ChaatBarDatabase? _database;

  DatabaseHelper._internal();

  Future<ChaatBarDatabase> get database async {
    if (_database != null) return _database!;
    _database = await $FloorChaatBarDatabase
        .databaseBuilder('basic_structure_database.db')
        .addMigrations([migration1to2])
        .build();
    return _database!;
  }
}

final Migration migration1to2 = Migration(1, 2, (database) async {
  await database.execute('ALTER TABLE ProductDataDB ADD COLUMN description TEXT');
});
