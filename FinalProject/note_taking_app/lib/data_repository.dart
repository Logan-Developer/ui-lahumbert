import 'dal.dart';

class DataRepository {
  final dal = DAL();
  Future<List<String>> fetchClasses() async {
    final db = await dal.db;
    final classes = await db.query('classes');
    return classes.map((e) => e['name'] as String).toList();
  }
}
