import 'dal.dart';

class DataRepository {
  final dal = DAL();
  Future<List<dynamic>> fetchClasses() async {
    final db = await dal.db;
    final classes = await db.query('classes');
    return classes.toList();
  }

  Future<List<dynamic>> fetchNotes(String className) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;
    final notes =
        await db.query('notes', where: 'classID = ?', whereArgs: [classID]);
    return notes.toList();
  }

  Future<Map<String, dynamic>> fetchNote(
      String className, String noteName) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;
    final note = await db.query('notes',
        where: 'classID = ? AND name = ?', whereArgs: [classID, noteName]);
    return note[0];
  }

  Future<void> addClass(String className) async {
    final db = await dal.db;
    await db.insert('classes', {'name': className});
  }

  Future<void> addNote(
      String className, String noteName, String content) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;
    await db.insert('notes', {
      'classID': classID,
      'name': noteName,
      'content': content,
    });

    await db.update('classes', {'lastUpdated': DateTime.now().toString()},
        where: 'id = ?', whereArgs: [classID]);
  }

  Future<void> deleteClass(String className) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;

    await db.delete('notes', where: 'classID = ?', whereArgs: [classID]);
    await db.delete('classes', where: 'id = ?', whereArgs: [classID]);
  }

  Future<void> deleteNote(String className, String noteName) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;
    await db.delete('notes',
        where: 'classID = ? AND name = ?', whereArgs: [classID, noteName]);

    await db.update('classes', {'lastUpdated': DateTime.now().toString()},
        where: 'id = ?', whereArgs: [classID]);
  }

  Future<void> updateClass(String oldClassName, String newClassName) async {
    final db = await dal.db;
    await db.update('classes', {'name': newClassName},
        where: 'name = ?', whereArgs: [oldClassName]);
  }

  Future<void> updateNote(String className, String oldNoteName,
      String newNoteName, String content) async {
    final db = await dal.db;
    final classData =
        await db.query('classes', where: 'name = ?', whereArgs: [className]);
    final classID = classData[0]['id'] as int;
    await db.update('notes', {'name': newNoteName, 'content': content},
        where: 'classID = ? AND name = ?', whereArgs: [classID, oldNoteName]);

    await db.update('classes', {'lastUpdated': DateTime.now().toString()},
        where: 'id = ?', whereArgs: [classID]);
  }
}
