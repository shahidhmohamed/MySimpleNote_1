import 'package:MySimpleNotes/database_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class AttachmentRepository {
  late DatabaseConnection _databaseConnection;

  AttachmentRepository() {
    _databaseConnection = DatabaseConnection(); // Initialize here
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase(); // Ensure database is initialized
      return _database;
    }
  }

  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> readData(String table) async {
    var connection = await database;
    return await connection?.query(table) ?? [];
  }

  Future<void> deleteDataById(String table, int itemId) async {
    var connection = await database;
    await connection?.rawDelete("DELETE FROM $table WHERE id = ?", [itemId]);
  }
}
