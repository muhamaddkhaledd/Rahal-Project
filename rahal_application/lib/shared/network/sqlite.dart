import 'package:sqflite/sqflite.dart';
Database? db;
List<Map> list = [];
void createdb()async
{
  db = await openDatabase(
      'datas.db',
    version: 1,
    onCreate: (db, version) {
        db.execute('CREATE TABLE databasedata (id INTEGER PRIMARY KEY,name TEXT)').then((value) {
          print('table created');
        });
    },
  );
}
void insertdb(String name)async
{
  await db!.transaction((txn) async{
   await txn.rawInsert('INSERT INTO databasedata (name) VALUES ($name)').then((value) {
     print('$name added successfully');
   });
  });
}
void getdataformdb()async
{
  list = await db!.rawQuery('SELECT * FROM databasedata');
  print(list);
}