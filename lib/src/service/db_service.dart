import 'package:mongo_dart/mongo_dart.dart';

class DbService {
  late Db _db;
  Db get db => _db;
  bool _isOpen = false;

  Future<void> openDb() async {
    try {
      _db = await Db.create('mongodb://localhost:27017/dart_movie_api');
      await _db.open();
      _isOpen = true;
      print('Database connected');
    } catch (e) {
      print('Error: $e');
    }
  }

  DbCollection getStore(String store) {
    if (!_isOpen) throw DatabaseNotOpenException('Database is not open');
    return _db.collection(store);
  }

  @override
  String toString() {
    return "DbService HashCode: $hashCode";
  }
}

class DatabaseNotOpenException implements Exception {
  final String message;
  DatabaseNotOpenException(this.message);
}
