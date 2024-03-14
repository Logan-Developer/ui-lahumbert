import 'dal.dart';

class DataRepository {
  final dal = DAL();
  Future<List<String>> fetchClasses() async {
    final db = await dal.db;
    final classes = await db.query('classes');
    return classes.map((e) => e['name'] as String).toList();
  }

  Future<List<String>> fetchNotes(String className) async {
    final db = await dal.db;
    final notes =
        await db.query('notes', where: 'class = ?', whereArgs: [className]);
    return notes.map((e) => e['name'] as String).toList();
  }

  Future<void> addClass(String className) async {
    final db = await dal.db;
    await db.insert('classes', {'name': className});
  }

  Future<void> addNote(
      String className, String noteName, String content) async {
    final db = await dal.db;
    await db.insert(
        'notes', {'class': className, 'name': noteName, 'content': content});
  }
}
