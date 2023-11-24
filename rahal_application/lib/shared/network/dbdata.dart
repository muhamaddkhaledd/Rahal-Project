import 'package:sqflite/sqflite.dart';
class Sqldb
{
  static Database? _db;
  Future<Database?> get db async
  {
    if(_db==null){
      _db= await initialdb();
      return _db;
    }
    else{
      return _db;
    }
  }
  initialdb()async
  {
    Database db= await openDatabase('database.db',onCreate: (db, version) {
      db.execute('CREATE TABLE "data" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,"name" TEXT)');
      print('database and table created');
    },
      version: 1,
    );
    return db;
  }
  Future<List<Map>>readData(String sql)async
  {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }
  Future<int>insertData(String sql)async
  {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
  Future<int>updateData(String sql)async
  {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
  Future<int>deleteData(String sql)async
  {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}