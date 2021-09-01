import 'package:note/database/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int ver) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final colorType = 'INTEGER NOT NULL';
    final uriImageWebLinkType = 'TEXT';
    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFields.id} $idType,
        ${NoteFields.title} $textType,
        ${NoteFields.content} $textType,
        ${NoteFields.uriImage} $uriImageWebLinkType,
        ${NoteFields.webLink} $uriImageWebLinkType,
        ${NoteFields.typeColor} $colorType
      )
    ''');
  }

  Future<void> create(Note note) async {
    final db = await instance.database;
    final idInsert = await db.insert(tableNotes, note.toJson());
    if (idInsert != 0)
      print('Insert done !');
    else
      throw Exception('Insert Faild');
    ;
  } //insert

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else
      throw Exception('ID $id not found');
  }

  Future<List<Note>> readAllNote() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.id} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
