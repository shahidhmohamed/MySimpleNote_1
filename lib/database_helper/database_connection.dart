import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MySimpleNote.db');
    // print("Database path: $path"); // Keep for debugging; consider removing in production
    var database = await openDatabase(
      path,
      version: 4,
      onCreate: _createDatabase,

    );
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql = """
      CREATE TABLE notes (
        note_id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        created_at TEXT,
        book_marked BOOLEAN
      );
    """;

    String attachmentsSql = """
      CREATE TABLE attachments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      );
    """;
    await database.execute(sql);
    await database.execute(attachmentsSql);
  }

  // Future<void> _onUpgrade(Database database, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     await database.execute("ALTER TABLE notes ADD COLUMN created_at TEXT;");
  //   }
  //   if (oldVersion < 3) {
  //     await database.execute("ALTER TABLE notes ADD COLUMN book_marked BOOLEAN DEFAULT 0;");
  //   }
  //   if (oldVersion < 4) {
  //     // Ensure the attachments table is only created if it doesn't exist
  //     await database.execute("""
  //       CREATE TABLE IF NOT EXISTS attachments (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         name TEXT
  //       );
  //     """);
  //   }
  // }

}
